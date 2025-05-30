{ stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "terminal";
  version = "1.06";

  src = fetchFromGitHub {
    owner = "adamharrison";
    repo = "lite-xl-terminal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gfd+lcpZO6hJkKKTcX+jEOZTeQAvgC8f+o+HMubPNS4=";
    fetchSubmodules = true;
  };

  buildPhase = ''
    runHook preBuild

    BIN=libterminal.so bash build.sh -std=c99 -D_BSD_SOURCE -D_POSIX_SOURCE -O3

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp $src/plugins/terminal/init.lua $out/init.lua
    mv libterminal.so $out/libterminal.so

    runHook postInstall
  '';
})

