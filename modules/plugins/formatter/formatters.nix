{ lib, pkgs, ... }:
let
  inherit (lib) genPluginPaths getPackageSrc;

  formatterNames = [
    "autoflake" "black" "clangformat" "cljfmt" "cmakeformat" "crystal" "csharpier"
    "cssbeautify" "dartformat" "dfmt" "elixir" "elmformat" "esformatter" "gdformat"
    "golang" "googlejavaformat" "htmlbeautify" "isort" "jsbeautify" "juliaformatter"
    "luaformatter" "ocpindent" "ormolu" "perltidy" "prettier" "qmlformat" "rubocop"
    "ruff" "rustfmt" "shfmt" "sqlformatter" "vfmt" "zigfmt"
  ];

  frm = getPackageSrc "plg-formatters" pkgs;

  formatterPaths = genPluginPaths "${frm}/formatter_" formatterNames [ ] { };
in formatterPaths

