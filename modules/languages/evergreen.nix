{ lib, pkgs, ... }:
let
  inherit (lib) genAttrs mergeAttrsList;
  inherit (pkgs) callPackage;

  evergreenLanguageStrings = [
    "c" "cpp" "css" "d" "ecma" "go" "gomod" "gosum" "html" "html_tags"
    "javascript" "jsx" "julia" "lua" "rust" "zig"
  ];

  languages = callPackage ./evergreen { };
  deps = import ./evergreen/deps.nix { };

  # Generate attrset of evergreen language to source derivation
  # -> {
  #   lang1 = "<deriv1>";
  #   lang2 = "<deriv2>";
  #   lang3 = "<deriv3>";
  # }
  evrgLanguages = genAttrs evergreenLanguageStrings (name: (callPackage ./evergreen/sources.nix { inherit name languages deps; }));
in
mergeAttrsList [
  evrgLanguages
]

