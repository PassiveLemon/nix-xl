{ version
, src
, stdenv
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tree_sitter";
  inherit version src;

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

