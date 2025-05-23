{ inputs, lib, pkgs, ... }:
let
  inherit (lib) mergeAttrsList;
  inherit (pkgs) fetchFromGitHub;

  libraryPackages = import ./pkgs { inherit inputs lib pkgs; };
in
# Set up library structure
# {
#   "<name>" = "<source>";
# }
mergeAttrsList [
  {
    "widget" = fetchFromGitHub {
      owner = "lite-xl";
      repo = "lite-xl-widgets";
      rev = "dcf1c8c7087638b879d5c9c835686ccd79f963ec";
      hash = "sha256-6oOxJPRzDwpFh9wp20WocT3gB0wQpA3LI4IarF0hMfw=";
    };
  }
  libraryPackages
]

