{ lib, pkgs, ... }:
let
  inherit (lib) getPackage genAttrs mergeAttrsList;

  frm = (getPackage "plg-formatters" pkgs).src;

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

