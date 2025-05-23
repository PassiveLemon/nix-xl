{ stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "devicons";
  version = "4e6f401ba6689aca74822f08ba1d387027df6c9b";

  src = fetchFromGitHub {
    owner = "PerilousBooklet";
    repo = "lite-xl-devicons";
    rev = finalAttrs.version;
    hash = "sha256-rjd57U1cay9mwSDKw/BlfsNr32D1ujm26wXgRUYcgYI=";
  };

  buildPhase = "";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp $src/devicons.lua $out/init.lua
    cp $src/fontello-974160e7/font/devicons.ttf $out/devicons.ttf

    runHook postInstall
  '';
})

