{ lib, pkgs, ... }:
let
  inherit (lib) packager packagerGit getPackage mergeAttrsList;
  fonts = import ./fonts.nix { inherit lib pkgs; };
in
mergeAttrsList [
  fonts
  {
    coro_diff = packager (getPackage "lib-coro_diff" pkgs) ./coro_diff.nix;
    encoding = packager (getPackage "lib-encoding" pkgs) ./encoding.nix;
    net = packager (getPackage "lib-net" pkgs) ./net.nix;
    threads = packager (getPackage "lib-threads" pkgs) ./threads.nix;
    tree_sitter = packager (getPackage "lib-tree_sitter" pkgs) ./tree_sitter.nix;
    # www = packagerGit (getPackage "lib-www" pkgs) ./www.nix;
  }
]

