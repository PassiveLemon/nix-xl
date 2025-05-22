{ inputs, lib, pkgs, ... }:
let
  inherit (lib) attrNames;
  inherit (pkgs) fetchFromGitHub;

  libraryPackages = import ./pkgs { inherit inputs pkgs; };

  # "<name>" = "<source>";
  externalLibraries = {
    inherit (libraryPackages) coro_diff encoding font_nonicons font_symbols_nerdfont_mono_regular threads tree_sitter www;
    "widget" = fetchFromGitHub {
      owner = "lite-xl";
      repo = "lite-xl-widgets";
      rev = "dcf1c8c7087638b879d5c9c835686ccd79f963ec";
      hash = "sha256-6oOxJPRzDwpFh9wp20WocT3gB0wQpA3LI4IarF0hMfw=";
    };
  };

  # Take the name of each library in externalLibraries
  libraryStrings = attrNames externalLibraries;
in
{
  supportedLibraryStrings = libraryStrings;
  supportedLibraries = externalLibraries;
}

