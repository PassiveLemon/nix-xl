{ lib, ... }:
let
  inherit (lib) subImport mapAttrs recursiveUpdate;

  supportedLanguages = subImport ./external.nix;

  templateDeps = mapAttrs (_: _: [ ]) supportedLanguages;
in recursiveUpdate templateDeps {
  cpp = [ "c" ];
  html = [ "html_tags" ];
  javascript = [ "ecma" "jsx" ];
}

