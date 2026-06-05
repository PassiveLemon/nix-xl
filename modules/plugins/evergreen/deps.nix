{ lib, ... }:
let
  inherit (lib) mapAttrs recursiveUpdate;
  inherit (lib) subImport; # Custom

  supportedLanguages = subImport ./external.nix;

  templateDeps = mapAttrs (_: _: [ ]) supportedLanguages;
in recursiveUpdate templateDeps {
  cpp = [ "c" ];
  html = [ "html_tags" ];
  javascript = [ "ecma" "jsx" ];
}

