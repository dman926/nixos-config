#!/usr/bin/env bash

help() {
  ZERO="$0"
  if [[ "${ZERO::1}" == "/" ]]; then
    ZERO=$(basename $ZERO)
  fi
  cat <<EOF
Transcode a set of files using ffmpeg

Usage: $ZERO file-path [...]

Options:
  -h, --help      Display this help message

Transcode settings:
  Video
    Black-bar crop detection
    H265 HEVC using NVENC
  Audio:
    English and Japanese audio
    Each track transcodes to three tracks
      Passthrough, AC3 5.1, and AAC stereo
  Subtitles:
    English, Japanese, and Unknown subtitles

EOF
}

FILES=()

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
  -h | --help)
    help
    exit 0
    ;;
  *)
    FILES+=("$key")
    ;;
  esac

  shift
done

# Actual transcoding

WORK_DIR="."

# Ensure the working directories exist
mkdir -p $WORK_DIR/processing
mkdir -p $WORK_DIR/processed

for file in "${FILES[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Does not exist. Skipping: $file"
    continue
  fi

  base=$(basename "$file")
  filename="${base%.*}"

  echo "Processing $filename"

  # Black bar crop detection

  # Get chunks to look for bars
  total_runtime=$(ffprobe -v error -select_streams v:0 -show_entries format=duration -of csv=p=0 "$file" | awk '{printf "%d", $0}')
  trim_time=10
  available_seconds=$((total_runtime - $trim_time * 2))
  if [[ $total_runtime < 900 ]]; then # runtime less than 15 minutes
    max_sub_sections=$((total_runtime / 30))
    max_sub_sections=$((max_sub_sections < 10 ? max_sub_sections : 10))
  elif [[ $total_runtime < 3600 ]]; then # runtime less than 1 hour
    max_sub_sections=10
  else
    max_sub_sections=$((total_runtime / 3600 * 5))
  fi
  min_gap_seconds=$((available_seconds / (max_sub_sections - 1)))
  sub_section_duration=30
  skip_times=()
  current_time=$trim_time
  for ((i = 1; i <= max_sub_sections; i++)); do
    current_time=$((current_time + min_gap_seconds))

    if ((current_time <= available_seconds)); then
      skip_times+=($current_time)
    else
      break
    fi
  done

  # Original video stream widthxheight
  dimensions=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$file")

  IFS='x' read -r dimension_w dimension_h <<<"$dimensions"

  crop_factor=""
  scale_factor=""
  smallest_width_height_sum=0

  for skip_time in "${skip_times[@]}"; do
    {
      read internal_crop_factor
      read internal_scale_factor
    } <<<$(ffmpeg -nostats -ss $skip_time -i "$file" -t 30 -vf cropdetect=reset=1 -f null - 2>&1 |
      grep -v '^\[out#0/null @' |
      sed -ne 's/\[[^][]*\] //p' |
      awk -v old_w=$dimension_w -v old_h=$dimension_h '
        BEGIN {
          max = 0
        }
        $12!=old {
          match($0, /x1:([0-9]+) x2:([0-9]+) y1:([0-9]+) y2:([0-9]+) w:([0-9]+) h:([0-9]+)/, a)
          if (length(a) != 0) {
            new_w = a[5]
            new_h = a[6]
            if (new_w + new_h > max) {
              max = new_w + new_h
              x1 = a[1]
              x2 = old_w - 1 - a[2]
              y1 = a[3]
              y2 = old_h - 1 - a[4]
              width = new_w
              height = new_h
            }
          }
        }
        {old=$12}
        END {
          print width ":" height ":" x1 ":" y1
          print width ":" height
        }')

    if [[ $internal_crop_factor == ":::" || $internal_scale_factor == ":" ]]; then
      continue
    fi

    # Extract the width and height from the crop factor
    width_height=$(echo $internal_scale_factor | cut -d':' -f1-2)
    width_height_sum=$((${width_height%%:*} + ${width_height##*:})) # Sum of width and height

    # Check if the current crop factor is the smallest so far
    if [[ -z $scale_factor || $width_height_sum -gt $smallest_width_height_sum ]]; then
      crop_factor=$internal_crop_factor
      scale_factor=$internal_scale_factor
      smallest_width_height_sum=$width_height_sum
    fi
  done

  if [[ -n $scale_factor && $scale_factor != "${dimension_w}:${dimension_h}" ]]; then
    filter="-vf crop=$crop_factor,scale=$scale_factor,setsar=1 "
  else
    filter=""
  fi

  # Audio and Subtitle Tracks
  # English and Japanese Audio
  # Each track gets mapped to:
  #  1. Passthrough
  #  2. AC3 5.1
  #  3. AAC stereo
  audioTracks=($(ffprobe -v error -select_streams a -show_entries "stream=index:stream_tags=language" -of csv=p=0 "$file" | grep -E '(eng|jpn)$' | awk '{
      split($0, a, ",") 
      track_num_0 = (FNR - 1) * 3
      track_num_1 = (FNR - 1) * 3 + 1
      track_num_2 = (FNR - 1) * 3 + 2
      print \
        "-map 0:" a[1] " -c:a:" track_num_0 " copy " \
        "-map 0:" a[1] " -c:a:" track_num_1 " ac3 -ac 6 " \
        "-map 0:" a[1] " -c:a:" track_num_2 " aac -ac 2"
    }'))
  # English, Japanese, and Unknown Subtitles
  subtitleTracks=($(ffprobe -v error -select_streams s -show_entries "stream=index:stream_tags=language" -of csv=p=0 "$file" | grep -E '(eng|jpn|,)$' | awk '{
      split($0, a, ",") 
      track_num_0 = FNR - 1
      print \
        "-map 0:" a[1] " -c:s:" track_num_0 " copy" \
    }'))

  # Process
  ffmpeg -y -v error -stats \
    -hwaccel cuda \
    -i "$file" \
    -map 0:v $filter-c:v hevc_nvenc -preset:v p7 -tune:v hq -rc:v vbr -cq:v 30 -b:v 0 -profile:v main \
    ${audioTracks[@]} \
    ${subtitleTracks[@]} \
    "$WORK_DIR/processing/${filename}.mkv" </dev/null &&
    mv "$WORK_DIR/processing/${filename}.mkv" "$WORK_DIR/processed/${filename}.mkv"

  echo "Processed $filename"
done

echo "Finished!"
