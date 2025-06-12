{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types attrNames match mapAttrs' nameValuePair elem;
  cfg = config.programs.lite-xl;

  enableFonts = import ./pack.nix { inherit config lib pkgs; };
  supportedFonts = import ./fonts.nix { inherit pkgs; };
  fontStrings = attrNames supportedFonts;

  # Append the extension from the font source to the font name for xdgEntries
  getExtension = path:
    let
      ext = match ".*(\\.[^./]+)$" path;
    in
      if ext != null
      then builtins.elemAt ext 0
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
      font = mkOption {
        type = types.oneOf [(types.enum fontStrings)];
        default = "";
      };
      # customFont = mkOption {
      #   type = types.submodule {
      #     options = {
      #       name = mkOption {
      #         type = types.str;
      #       };
      #       value = mkOption {
      #         type = types.path;
      #       };
      #     };
      #   };
      # };
      codeFont = mkOption {
        type = types.oneOf [(types.enum fontStrings)];
        default = "";
      };
      # customCodeFont = mkOption {
      #   type = types.submodule {
      #     options = {
      #       name = mkOption {
      #         type = types.str;
      #       };
      #       value = mkOption {
      #         type = types.path;
      #       };
      #     };
      #   };
      # };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = xdgEntries;
  };
}

