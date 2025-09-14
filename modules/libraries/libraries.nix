{ lib, pkgs, ... }:
let
  inherit (lib) getPackageSrc mergeAttrsList;

  lsp = getPackageSrc "lib-lsp-servers" pkgs;

  libraryPackages = import ./pkgs { inherit lib pkgs; };
in
# Libraries that are a single file should have the source set to the exact init.lua file
# Libraries that are multiple files should have the source set to the root where init.lua is

# Library structure
# {
#   "<name>" = "<source>";
# }
mergeAttrsList [
  libraryPackages
  {
    "widget" = getPackageSrc "lib-widgets" pkgs;
    "json" = "${getPackageSrc "lib-json" pkgs}/json.lua";
    "golang" = "${lsp}/libraries/golang.lua";
    "haxe" = "${lsp}/libraries/haxe.lua";
    "jdk" = "${lsp}/libraries/jdk.lua";
    "nodejs" = "${lsp}/libraries/nodejs.lua";
  }
]

