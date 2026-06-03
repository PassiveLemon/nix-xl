{ lib, ... }:
let
  inherit (lib) subImport mapAttrs recursiveUpdate;

  supportedLanguages = subImport ./languages.nix;

  templateDeps = mapAttrs (_: _: [ ]) supportedLanguages;
in recursiveUpdate templateDeps {
  cpp = [ "c" ];
  html = [ "html_tags" ];
  html_tags = [ ];
  javascript = [ "ecma" "jsx" ];
}

