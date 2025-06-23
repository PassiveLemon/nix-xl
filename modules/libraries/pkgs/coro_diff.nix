{ version
, src
, stdenv
, meson
, ninja
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "coro_diff";
  inherit version src;

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildPhase = ''
    runHook preBuild

    cd /build/source

    meson setup --buildtype=release build
    meson compile -C build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv build/myers_midpoint.so $out/init.so

    runHook postInstall
  '';
})

