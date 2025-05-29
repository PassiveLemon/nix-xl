{ lib, pkgs, ... }:
let
  inherit (lib) genAttrs mergeAttrsList;
  inherit (pkgs) fetchgit;

  lsp = fetchgit {
    url = "https://github.com/lite-xl/lite-xl-lsp-servers";
    rev = "6eea7cf124baad8e7abad6e388c7a16f6f6a98f2";
    hash = "sha256-rKhltQ9uGnT5PJPmotxMxQm6xNO9y14klCdae8aNXcU=";
  };

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

