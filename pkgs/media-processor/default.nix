{ stdenv
, lib
, bash
, ffmpeg-full
, work-dir ? "/media/memebigboi/media"
,
}:
stdenv.mkDerivation rec {
  name = "media-processor";
  version = "0.1.0";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ bash ffmpeg-full ];

  src = ./.;

  # TODO: Maybe not needed
  # phases = [ "installPhase" "fixupPhase" ];
  # or
  # phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    for script in renamer transcoder
    do 
      cp ${src}/$script.sh $out/bin/$script
      chmod +x $out/bin/$script
    done

    if [ -n "${work-dir}" ]; then
      substituteInPlace $out/bin/transcoder \
        --replace 'WORK_DIR="."' 'WORK_DIR="${work-dir}"'
    fi

    wrapProgram $out/bin/transcoder \
        --prefix PATH ${pkgs.lib.makeBinPath [ pkgs.ffmpeg-full ]}
  '';

  meta = {
    description = "A tool to rename and convert media files";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
