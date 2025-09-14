{ lib, pkgs, ... }:
let
  inherit (lib) getPackageSrc;
in
# TODO: We might be able to get these from lock.json

# Language structure
# "<lang>" = "<source>";
{
  "c" = getPackageSrc "plg-evg-c" pkgs;
  "cpp" = getPackageSrc "plg-evg-cpp" pkgs;
  "css" = getPackageSrc "plg-evg-css" pkgs;
  "d" = getPackageSrc "plg-evg-d" pkgs;
  "ecma" = "";
  "go" = getPackageSrc "plg-evg-go" pkgs;
  "gomod" = getPackageSrc "plg-evg-gomod" pkgs;
  "gosum" = getPackageSrc "plg-evg-gosum" pkgs;
  "html" = getPackageSrc "plg-evg-html" pkgs;
  "html_tags" = "";
  "javascript" = getPackageSrc "plg-evg-javascript" pkgs;
  "jsx" = "";
  "julia" = getPackageSrc "plg-evg-julia" pkgs;
  "lua" = getPackageSrc "plg-evg-lua" pkgs;
  "rust" = getPackageSrc "plg-evg-rust" pkgs;
  "zig" = getPackageSrc "plg-evg-zig" pkgs;
}

