#!/bin/sh

function print_usage {
  echo "Usage: $0 [OPTIONS] <file_prefix> <folder_name>"
  echo "Options:"
  echo "  --dry-run       Print out the new filenames, but don't actually rename the files"
}

function print_rename_info {
  printf '%-*s    %s\n' "$max_filename_length" "$1" "$2"
}

function rename_file {
  old_name="$1"
  new_name="$2"

  print_rename_info "$old_name" "$new_name"
  if [ "$dry_run" = false ]; then
    mv "$old_name" "$new_name"
  fi
}

file_prefix=
folder_name=
dry_run=false

# Parse options
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --dry-run) dry_run=true ;;
    -h|--help) print_usage; exit 0 ;;
    *)
      if [ -z "$file_prefix" ]; then
        file_prefix=$1
      elif [ -z "$folder_name" ]; then
        folder_name=$1
      else
        echo "Invalid argument: $1"
        print_usage
        exit 1
      fi
      ;;
  esac
  shift
done

if [ -z "$file_prefix" ] || [ -z "$folder_name" ]; then
  print_usage
  exit 1
fi

if [ ! -d "$folder_name" ]; then
  echo "Error: Folder '$folder_name' does not exist."
  exit 1
fi

cd "$folder_name"

# Get all files in directory using glob expression
files=(*)

# Sort files alphabetically
IFS=$'\n' files=($(sort <<<"${files[*]}"))
unset IFS

total_files=${#files[@]}
padding=$(( ${#total_files} > 2 ? ${#total_files} : 2 ))

max_filename_length=0

for file in "${files[@]}"
do
  if [ ${#file} -gt $max_filename_length ]; then
    max_filename_length=${#file}
  fi
done

COUNT=1

for file in "${files[@]}"
do
  old_name="$file"
  new_name="${file_prefix}$(printf "%0${padding}d" $COUNT).mkv"

  rename_file "$old_name" "$new_name"

  COUNT=$((COUNT+1))
done
