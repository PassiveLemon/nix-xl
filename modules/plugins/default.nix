{ config, lib, pkgs, ... }:
let
  inherit (lib) genNamedPaths subImport mkIf mkOption types attrNames;
  cfg = config.programs.lite-xl;

  enablePlugins = import ./pack.nix { inherit config lib pkgs; };
  supportedPlugins = import ./plugins.nix { inherit lib pkgs; };
  pluginStrings = attrNames supportedPlugins;

  xdgEntries = genNamedPaths "lite-xl/plugins/" enablePlugins;
in
{
  options = {
    programs.lite-xl.plugins = {
      enableList = mkOption {
        type = types.listOf (types.enum pluginStrings);
        default = [ ];
      };
      customEnableList = mkOption {
        type = types.attrsOf types.path;
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

