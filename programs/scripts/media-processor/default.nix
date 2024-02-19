{ pkgs ? import <nixpkgs> { }, work-dir ? "" }:
let
  name = "media-processor";
  version = "0.1.0";
in
pkgs.stdenv.mkDerivation rec {
  inherit name;
  inherit version;
  src = ./.;
  buildInputs = with pkgs; [ bash ffmpeg-full ];
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  phases = [ "installPhase" "fixupPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    for script in renamer transcoder
    do 
      cp ${src}/$script.sh $out/bin/$script
      chmod +x $out/bin/$script
    done

    if [[ "${work-dir}" != "" ]]; then
      substituteInPlace $out/bin/transcoder \
        --replace 'WORK_DIR="."' 'WORK_DIR="${work-dir}"'
    fi

    wrapProgram $out/bin/transcoder \
        --prefix PATH ${pkgs.lib.makeBinPath [ pkgs.ffmpeg-full ]}
  '';
}

