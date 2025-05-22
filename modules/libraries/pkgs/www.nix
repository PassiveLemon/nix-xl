{ stdenv
, fetchFromGitHub
, cmake
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "www";
  version = "9372c39dafb2a0cbb21ac3b8f7ba420214872524";

  src = fetchFromGitHub {
    owner = "adamharrison";
    repo = "lite-xl-www";
    rev = finalAttrs.version;
    hash = "sha256-BOgUmkfhmU0KXwZALWq1sEktWJKm3ILHBCjPrD08bjk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildPhase = ''
    runHook preBuild

    mkdir $out

    BIN="$out/init.so" bash build.sh

    runHook postBuild
  '';

  # installPhase = ''
  #   runHook preInstall

  #   mkdir $out
  #   mv lua-tree-sitter/lua_tree_sitter.so $out/init.so

  #   runHook postInstall
  # '';
})

