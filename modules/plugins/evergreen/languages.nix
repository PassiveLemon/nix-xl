{ lib, pkgs, ... }:
let
  inherit (lib) subImport genAttrs;

  evergreenLanguageStrings = [
    "c" "cpp" "css" "d" "ecma" "go" "gomod" "gosum" "html" "html_tags"
    "javascript" "jsx" "julia" "lua" "rust" "zig"
  ];

  languages = subImport ./external.nix;
  deps = subImport ./deps.nix;

  # Generate attrset of evergreen language to source derivation
  # -> {
  #   lang1 = "<deriv1>";
  #   lang2 = "<deriv2>";
  # }
  evrgLanguages = genAttrs evergreenLanguageStrings (name: (pkgs.callPackage ./sources.nix { inherit name languages deps lib; }));
in evrgLanguages

