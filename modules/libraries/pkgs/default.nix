{ inputs, lib, pkgs, ... }:
let
  inherit (lib) mergeAttrsList;
  inherit (pkgs) callPackage;
  fonts = import ./fonts.nix { inherit inputs pkgs; };
in
mergeAttrsList [
  {
    coro_diff = callPackage ./coro_diff.nix { };
    encoding = callPackage ./encoding.nix { };
    threads = callPackage ./threads.nix { };
    tree_sitter = callPackage ./tree_sitter.nix { };
    # www = callPackage ./www.nix { };
  }
  fonts
]

