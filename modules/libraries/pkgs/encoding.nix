{ stdenv
, fetchFromGitHub
, libuchardet
, meson
, ninja
, pkg-config
, SDL2
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "encoding";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "jgmdev";
    repo = "lite-xl-encoding";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fN1f0IXmJoZwXXlRixc1wpZsXgRsQXBNypDJUW+UEjY=";
  };

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

    meson setup --buildtype=release build
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

