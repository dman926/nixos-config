{ stdenv
, lib
, pkg-config
, steam-run
, buildFHSEnv
, libusb1
, libcxx
, ncurses5
, python2
}:

let
  pname = "ccstudio";
  version = "12.6.0.00008";

  ccstudio = stdenv.mkDerivation rec {
    inherit pname version;

    buildInputs = [ libusb1 libcxx ncurses5 python2 ];
    nativeBuildInputs = [ pkg-config steam-run ];

    src = builtins.fetchTarball {
      url =
        let
          versionList = builtins.splitVersion version;
          baseVersion = builtins.concatStringsSep "." (lib.lists.take 3 versionList);
        in
        "https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-J1VdearkvK/${baseVersion}/CCS${version}_linux-x64.tar.gz";
      sha256 = "1qwa8b1win64w60xpf52ws65ga0xyaixh8fzl1ix9misgblpdpz7";
    };

    installPhase = ''
            mkdir -p $out/etc/ti/ccs1260
            ${steam-run}/bin/steam-run ${src}/ccs_setup_${version}.run --mode unattended --prefix $out/etc/ti/ccs1260 <<EOF

      EOF
    '';
  };
in
buildFHSEnv {
  name = pname;

  targetPkgs = pkgs: [
    ccstudio
  ];

  runScript = "DecentSampler";

  meta = {
    description = "an integrated development environment for TI's microcontrollers and processors";
    homepage = "https://www.ti.com/tool/CCSTUDIO";
    platforms = lib.platforms.linux;
  };
}
