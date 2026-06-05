{ config, lib, ... }:
let
  inherit (lib) subImport mkIf mkEnableOption mkOption types attrNames match mapAttrs' nameValuePair elemAt;
  cfg = config.programs.lite-xl;

  enableFonts = subImport ./pack.nix;
  supportedFonts = subImport ./fonts.nix;
  fontStrings = attrNames supportedFonts;

  # Append the extension from the font source to the font name for xdgEntries
  getExtension = path:
    let
      ext = match ".*(\\.[^./]+)$" path;
    in
      if ext != null
      then elemAt ext 0
      else "";

  xdgEntries = mapAttrs' (name: source:
    let
      ext = getExtension source;
    in
    nameValuePair "lite-xl/fonts/${name}${ext}" { source = source; })
    enableFonts;
in
{
  options = {
    programs.lite-xl.fonts = {
      enable = mkEnableOption "lite-xl font configuration";
      font = mkOption {
        type = types.oneOf [(types.enum fontStrings)];
        default = "FiraCodeNerdFont-Retina";
      };
      customFont = mkOption {
        type = types.submodule {
          options = {
            name = mkOption {
              type = types.str;
            };
            value = mkOption {
              type = types.path;
            };
          };
        };
        default = { name = ""; value = ""; };
      };
      codeFont = mkOption {
        type = types.oneOf [(types.enum fontStrings)];
        default = "FiraCodeNerdFontMono-Retina";
      };
      customCodeFont = mkOption {
        type = types.submodule {
          options = {
            name = mkOption {
              type = types.str;
            };
            value = mkOption {
              type = types.path;
            };
          };
        };
        default = { name = ""; value = ""; };
      };
    };
  };

  config = mkIf cfg.fonts.enable {
    xdg.configFile = xdgEntries;
  };
}

