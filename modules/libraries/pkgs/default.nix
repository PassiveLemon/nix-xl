{ lib, pkgs, ... }:
let
  inherit (lib) packager mergeAttrsList;
  fonts = import ./fonts.nix { inherit lib pkgs; };
in
mergeAttrsList [
  fonts
  {
    coro_diff = packager "lib-coro_diff" ./coro_diff.nix pkgs { };
    encoding = packager "lib-encoding" ./encoding.nix pkgs { };
    net = packager "lib-net" ./net.nix pkgs { };
    threads = packager "lib-threads" ./threads.nix pkgs { };
    tree_sitter = packager "lib-tree_sitter" ./tree_sitter.nix pkgs { };
    # www = packagerGit "lib-www" ./www.nix pkgs { };
  }
]

