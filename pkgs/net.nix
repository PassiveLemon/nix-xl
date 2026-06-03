{ version
, src
, stdenv
, meson
, ninja
, pkg-config
, SDL2_net
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "net";
  inherit version src;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    SDL2_net
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
    mv build/net.so $out/init.so

    runHook postInstall
  '';
})

