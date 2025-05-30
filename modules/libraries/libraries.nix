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
# Libraries that are a single file should have the source set to the exact init.lua file
# Libraries that are multiple files should have the source set to the root where init.lua is

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
    "json" = (fetchFromGitHub {
      owner = "rxi";
      repo = "json.lua";
      rev = "dbf4b2dd2eb7c23be2773c89eb059dadd6436f94";
      hash = "sha256-BrM+r0VVdaeFgLfzmt1wkj0sC3dj9nNojkuZJK5f35s=";
    }) + "/json.lua";
    "golang" = lsp + "/libraries/golang.lua";
    "haxe" = lsp + "/libraries/haxe.lua";
    "jdk" = lsp + "/libraries/jdk.lua";
    "nodejs" = lsp + "/libraries/nodejs.lua";
  }
]

