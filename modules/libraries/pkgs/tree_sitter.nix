{ stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tree_sitter";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Evergreen-lxl";
    repo = "lite-xl-tree-sitter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PdYBI8xATjGXbo9Xw/idJNSoW3dv6DhVRZHgsUFHdW0=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace make.sh \
      --replace-fail "rm src/plugin.c" ""
  '';

  buildPhase = ''
    runHook preBuild

    sh make.sh lua_tree_sitter.so CC=gcc 'LTS_CFLAGS=-std=c11'

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv lua-tree-sitter/lua_tree_sitter.so $out/init.so

    runHook postInstall
  '';
})

