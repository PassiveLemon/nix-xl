{ lib, pkgs, ... }:
let
  inherit (lib) genAttrs mergeAttrsList;
  inherit (pkgs) fetchgit;

  frm = fetchgit {
    url = "https://github.com/vincens2005/lite-formatters";
    rev = "9ec4ee7f650e7daf84ba5f733f4e9ec5899100ec";
    hash = "sha256-/VBs3UWh298g15tku/hfsLGCXzfNMDKpATJ8I/frlw4=";
  };

  formatterLanguageStrings = [
    "autoflake" "black" "clangformat" "cljfmt" "cmakeformat" "crystal" "csharpier"
    "cssbeautify" "dartformat" "dfmt" "elixir" "elmformat" "esformatter" "gdformat"
    "golang" "googlejavaformat" "htmlbeautify" "isort" "jsbeautify" "juliaformatter"
    "luaformatter" "ocpindent" "ormolu" "perltidy" "prettier" "qmlformat" "rubocop"
    "ruff" "rustfmt" "shfmt" "sqlformatter" "vfmt" "zigfmt"
  ];

  # Formatters plugin formatters prefix
  frmpf = "${frm}/formatter_";

  # Generate attrset of form to source file
  # -> {
  #   form1 = "<source1>.lua";
  #   form2 = "<source2>.lua";
  #   form3 = "<source3>.lua";
  # }
  frmLanguages = genAttrs formatterLanguageStrings (lang: "${frmpf}${lang}.lua");
in
# Formatter structure
# {
#   "<name>" = "<source>";
# }
mergeAttrsList [
  frmLanguages
]

