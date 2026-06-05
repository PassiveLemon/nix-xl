{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption types attrNames length optional flatten;
  inherit (lib) subImport genNamedPaths; # Custom
  cfg = config.programs.lite-xl;

  enablePlugins = subImport ./pack.nix;
  supportedPlugins = subImport ./plugins.nix;
  pluginStrings = attrNames supportedPlugins;

  xdgEntries = genNamedPaths "lite-xl/plugins/" enablePlugins;

  evergreenEnable = ((length cfg.plugins.evergreen.enableList) > 0) || cfg.plugins.evergreen.copyLanguages.enable;
  formatterEnable = (length cfg.plugins.formatter.enableList) > 0;
  lspEnable = (length cfg.plugins.lsp.enableList) > 0;
  
  metaEnableList = flatten (optional cfg.depRes [
    (optional evergreenEnable "evergreen")
    (optional formatterEnable "formatter")
    (optional lspEnable "lsp")
  ]);
in
{
  options = {
    programs.lite-xl.plugins = {
      enableList = mkOption {
        type = types.listOf (types.enum pluginStrings);
        description = "The list of plugins to enable.";
        default = [ ];
        apply = value: value ++ metaEnableList;
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

