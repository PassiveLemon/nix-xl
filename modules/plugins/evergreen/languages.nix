{ lib, pkgs, ... }:
let
  inherit (lib) subImport getDeps getPackage versionFromPackage getAttr genAttrs;

  # Evergreen is complex, there are dependencies for building the languages and among the languages themselves

  evergreenLanguageStrings = [
    "c" "cpp" "css" "d" "ecma" "go" "gomod" "gosum" "html" "html_tags"
    "javascript" "jsx" "julia" "lua" "rust" "zig"
  ];

  languages = subImport ./external.nix;
  deps = subImport ./deps.nix;

  evergreen = getPackage "plg-evg" pkgs;

  langDeps = name: getDeps name [ ] (dep: _: getAttr dep deps);

  # Generate attrset of evergreen language to source derivation
  # -> {
  #   lang1 = "<deriv1>";
  #   lang2 = "<deriv2>";
  # }
  evergreenLanguages = genAttrs evergreenLanguageStrings (name: (pkgs.callPackage ../../../pkgs/other/evergreen_lang.nix {
    inherit name languages lib;
    deps = langDeps name;
    version = versionFromPackage evergreen;
    src = evergreen.src;
  }));
in
evergreenLanguages

