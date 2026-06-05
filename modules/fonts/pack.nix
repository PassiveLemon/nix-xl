{ config, lib, ... }:
let
  inherit (lib) subImport listToAttrs nameValuePair getAttr;
  cfg = config.programs.lite-xl;

  supportedFonts = subImport ./fonts.nix;

  enableFont = cfg.fonts.font;
  enableCodeFont = cfg.fonts.codeFont;

  userFont = (
    if cfg.fonts.customFont.name == ""
    then nameValuePair enableFont (getAttr enableFont supportedFonts)
    else cfg.fonts.customFont
  );
  userCodeFont = (
    if cfg.fonts.customCodeFont.name == ""
    then nameValuePair enableCodeFont (getAttr enableCodeFont supportedFonts)
    else cfg.fonts.customCodeFont
  );

  finalFonts = listToAttrs [ userFont userCodeFont ];
in
finalFonts

