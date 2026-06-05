{ config, lib, ... }:
let
  inherit (lib) subImport genNamedPaths mkIf mkOption types attrNames;
  cfg = config.programs.lite-xl;

  enablePlugins = subImport ./pack.nix;
  supportedPlugins = subImport ./plugins.nix;
  pluginStrings = attrNames supportedPlugins;

  xdgEntries = genNamedPaths "lite-xl/plugins/" enablePlugins;
in
{
  options = {
    programs.lite-xl.plugins = {
      enableList = mkOption {
        type = types.listOf (types.enum pluginStrings);
        description = "The list of plugins to enable.";
        default = [ ];
      };
      customEnableList = mkOption {
        type = types.attrsOf types.path;
        description = "Enable custom plugins. A custom plugin will overwrite the same name plugin in enableList.";
        default = { };
      };
    };
  };

  imports = [
    (subImport ./evergreen)
    (subImport ./formatter)
    (subImport ./languages)
    (subImport ./lsp)
  ];

  config = mkIf cfg.enable {
    xdg.configFile = xdgEntries;
  };
}

