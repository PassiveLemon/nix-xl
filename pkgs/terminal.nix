{ version
, src
, stdenv
}:
stdenv.mkDerivation {
  pname = "terminal";
  inherit version src;

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
}

