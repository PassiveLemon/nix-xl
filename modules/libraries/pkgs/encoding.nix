{ version
, src
, stdenv
, libuchardet
, meson
, ninja
, pkg-config
, SDL2
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "encoding";
  inherit version src;

  nativeBuildInputs = [
    libuchardet
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
    mv build/encoding.so $out/init.so

    runHook postInstall
  '';
})

