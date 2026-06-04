{ version
, src
, stdenv
, meson
, ninja
, pkg-config
, SDL2
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "threads";
  inherit version src;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    SDL2
  ];

  buildPhase = ''
    runHook preBuild

    cd /build/source

    meson setup build
    meson compile -C build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv build/thread.so $out/init.so

    runHook postInstall
  '';
})

