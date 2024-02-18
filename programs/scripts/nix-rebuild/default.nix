{ pkgs ? import <nixpkgs> { }, config-home ? "" }:
let
  name = "nix-rebuild";
  version = "0.1.0";
in
pkgs.stdenv.mkDerivation rec {
  inherit name;
  inherit version;
  src = ./rebuild.sh;
  buildInputs = with pkgs; [ bash ];
  phases = [ "installPhase" "fixupPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/${name}
    chmod +x $out/bin/${name}
  '';
  fixupPhase = ''
    if [[ "${config-home}" != "" ]]; then
      substituteInPlace $out/bin/${name} \
        --replace "# config-home PLACEHOLDER" 'cd ${config-home}'
    fi
  '';
}
