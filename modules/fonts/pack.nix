{ config, lib, ... }:
let
  inherit (lib) subImport listToAttrs nameValuePair getAttr mergeAttrsList;
  cfg = config.programs.lite-xl;

  supportedFonts = subImport ./fonts.nix;

  enableFont = cfg.fonts.font;
  enableCodeFont = cfg.fonts.codeFont;

  userFont = (nameValuePair enableFont) (getAttr enableFont supportedFonts);
  userCodeFont = (nameValuePair enableCodeFont) (getAttr enableCodeFont supportedFonts);

  # customFont = cfg.fonts.customFont;
  # customCodeFont = cfg.fonts.customCodeFont;

  userFonts = listToAttrs [ userFont userCodeFont ]; # customFont customCodeFont
in
mergeAttrsList [
  userFonts
]

