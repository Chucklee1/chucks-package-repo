{
  buildFHSEnv,
  fetchurl,
  stdenvNoCC,
  ...
}: let
  pname = "mo2-lint";
  version = "7.0.0";

  mo2-lint = stdenvNoCC.mkDerivation {
    inherit pname version;
    src = fetchurl {
      url = "https://github.com/Furglitch/modorganizer2-linux-installer/releases/download/${version}/mo2-lint";
      hash = "sha256-bNc1VKVSe9u7zwLlcm0LTaDl/hJXVImd+rWuMp66NBc=";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/mo2-lint
      chmod +x $out/bin/mo2-lint
    '';
  };
in
  buildFHSEnv {
    name = pname;
    targetPkgs = pkgs: (with pkgs; [
      file
      glibc
      killall
      yad
      mo2-lint
      zlib
    ]);
    multiPkgs = pkgs:
      with pkgs; [
        libGL
        alsa-lib
      ];
    runScript = pname;
  }
