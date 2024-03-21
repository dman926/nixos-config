{ stdenv
, lib
, bash
, pkg-config
, config-home ? "~/Documents/code/nixos-config"
,
}:
stdenv.mkDerivation rec {
  name = "nix-rebuild";
  version = "0.1.0";

  buildInputs = [ pkg-config bash ];

  src = ./rebuild.sh;

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/${name}
    chmod +x $out/bin/${name}
  '';

  fixupPhase = ''
    if [ -n "${config-home}" ]; then
      substituteInPlace $out/bin/${name} \
        --replace "# config-home PLACEHOLDER" 'cd ${config-home}'
    fi
  '';

  meta = {
    description = "A tool to rebuild NixOS and Home Manager configurations";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
