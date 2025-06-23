{ lib, pkgs, ... }:
let
  inherit (lib) getPackage;
in
# TODO: We might be able to get these from lock.json

# Language structure
# "<lang>" = "<source>";
{
  "c" = (getPackage "plg-evg-c" pkgs).src;
  "cpp" = (getPackage "plg-evg-cpp" pkgs).src;
  "css" = (getPackage "plg-evg-css" pkgs).src;
  "d" = (getPackage "plg-evg-d" pkgs).src;
  "ecma" = "";
  "go" = (getPackage "plg-evg-go" pkgs).src;
  "gomod" = (getPackage "plg-evg-gomod" pkgs).src;
  "gosum" = (getPackage "plg-evg-gosum" pkgs).src;
  "html" = (getPackage "plg-evg-html" pkgs).src;
  "html_tags" = "";
  "javascript" = (getPackage "plg-evg-javascript" pkgs).src;
  "jsx" = "";
  "julia" = (getPackage "plg-evg-julia" pkgs).src;
  "lua" = (getPackage "plg-evg-lua" pkgs).src;
  "rust" = (getPackage "plg-evg-rust" pkgs).src;
  "zig" = (getPackage "plg-evg-zig" pkgs).src;
}

