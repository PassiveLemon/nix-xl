{ lib, pkgs, ... }:
let
  inherit (lib) getPackage genAttrs mergeAttrsList;

  lsp = (getPackage "lib-lsp-servers" pkgs).src;

  lspLanguageStrings = [
    "clojure" "c" "d" "emmet" "go" "haxe" "java" "json" "lua" "python"
    "quicklintjs" "rust" "tex" "typescript" "yaml" "zig"
  ];

  # LSP plugin servers prefix
  lspps = "${lsp}/plugins/lsp_";

  # Generate attrset of serv to source file
  # -> {
  #   serv1 = "<source1>.lua";
  #   serv2 = "<source2>.lua";
  #   serv3 = "<source3>.lua";
  # }
  lspLanguages = genAttrs lspLanguageStrings (serv: "${lspps}${serv}.lua");
in
# Server structure
# {
#   "<name>" = "<source>";
# }
mergeAttrsList [
  lspLanguages
]

