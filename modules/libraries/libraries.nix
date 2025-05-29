{ lib, pkgs, ... }:
let
  inherit (lib) mergeAttrsList;
  inherit (pkgs) fetchgit fetchFromGitHub;

  lsp = fetchgit {
    url = "https://github.com/lite-xl/lite-xl-lsp-servers";
    rev = "6eea7cf124baad8e7abad6e388c7a16f6f6a98f2";
    hash = "sha256-rKhltQ9uGnT5PJPmotxMxQm6xNO9y14klCdae8aNXcU=";
  };

  libraryPackages = import ./pkgs { inherit lib pkgs; };
in
# Library structure
# {
#   "<name>" = "<source>";
# }
mergeAttrsList [
  libraryPackages
  {
    "widget" = (fetchFromGitHub {
      owner = "lite-xl";
      repo = "lite-xl-widgets";
      rev = "dcf1c8c7087638b879d5c9c835686ccd79f963ec";
      hash = "sha256-6oOxJPRzDwpFh9wp20WocT3gB0wQpA3LI4IarF0hMfw=";
    });
    "golang" = lsp + "/libraries/golang.lua";
    "haxe" = lsp + "/libraries/haxe.lua";
    "jdk" = lsp + "/libraries/jdk.lua";
    "nodejs" = lsp + "/libraries/nodejs.lua";
  }
]

