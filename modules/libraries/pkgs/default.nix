{ inputs, pkgs, ... }:
let
  inherit (pkgs) callPackage;
  fonts = import ./fonts.nix { inherit inputs pkgs; };
in
{
  inherit (fonts) font_nonicons font_symbols_nerdfont_mono_regular;
  coro_diff = callPackage ./coro_diff.nix { };
  encoding = callPackage ./encoding.nix { };
  threads = callPackage ./threads.nix { };
  tree_sitter = callPackage ./tree_sitter.nix { };
  # www = callPackage ./www.nix { };
}

