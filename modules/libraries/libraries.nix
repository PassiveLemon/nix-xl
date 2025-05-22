{ lib, pkgs, ... }:
let
  inherit (lib) attrNames;
  inherit (pkgs) fetchgit;

  # Source should be fetched
  # "<name>" = "<source>";
  externalLibraries = {
    # "coro_diff" = fetchgit {
    #   url = "https://github.com/Guldoman/lite-xl-coro_diff";
    #   rev = "5f7d422cf6f03e958bbc32c714a81fc5aaef6970";
    #   hash = "";
    # };
    # "encoding" = fetchgit {
    #   url = "https://github.com/jgmdev/lite-xl-encoding";
    #   rev = "16e2477e916f52e18f6d63f5ac61ace58b0c5e45";
    #   hash = "";
    # };
    # "font_nonicons" = fetchgit {
    #   url = "";
    #   rev = "";
    #   hash = "";
    # };
    # "font_symbols_nerdfont_mono_regular" = fetchgit {
    #   url = "";
    #   rev = "";
    #   hash = "";
    # };
    # "threads" = fetchgit {
    #   url = "https://github.com/jgmdev/lite-xl-threads";
    #   rev = "c182db7ad82d6ca4b1a8840609d093e6d3cbc89a";
    #   hash = "";
    # };
    # "tree-sitter" = fetchgit {
    #   url = "https://github.com/Evergreen-lxl/lite-xl-tree-sitter";
    #   rev = "9463aec4b09f6b9bb4c1f56fb5ab923335f4e554";
    #   hash = "";
    # };
    "widget" = fetchgit {
      url = "https://github.com/lite-xl/lite-xl-widgets";
      rev = "dcf1c8c7087638b879d5c9c835686ccd79f963ec";
      hash = "sha256-6oOxJPRzDwpFh9wp20WocT3gB0wQpA3LI4IarF0hMfw=";
    };
    # "www" = fetchgit {
    #   url = "https://github.com/adamharrison/lite-xl-www";
    #   rev = "9372c39dafb2a0cbb21ac3b8f7ba420214872524";
    #   hash = "";
    # };
  };

  # Take the name of each library in externalLibraries
  libraryStrings = (attrNames externalLibraries);
in
{
  supportedLibraryStrings = libraryStrings;
  supportedLibraries = externalLibraries;
}

