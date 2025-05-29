{ lib, pkgs, ... }:
let
  inherit (lib) mergeAttrsList;
  inherit (pkgs) callPackage;
  fonts = import ./fonts.nix { inherit pkgs; };
in
mergeAttrsList [
  fonts
  {
    coro_diff = callPackage ./coro_diff.nix { };
    encoding = callPackage ./encoding.nix { };
    net = callPackage ./net.nix { };
    threads = callPackage ./threads.nix { };
    tree_sitter = callPackage ./tree_sitter.nix { };
    # www = callPackage ./www.nix { };
  }
]

