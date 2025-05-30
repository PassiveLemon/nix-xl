{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types attrNames mapAttrs' hasSuffix nameValuePair;
  cfg = config.programs.lite-xl;

  enablePlugins = import ./pack.nix { inherit config lib pkgs; };
  supportedPlugins = import ./plugins.nix { inherit lib pkgs; };
  pluginStrings = attrNames supportedPlugins;

  # Map enablePlugins attrset to xdg.configFile entries
  # -> {
  #   "lite-xl/plugins/plugin1/" = { source = "<source1>/"; recursive = true; }
  #   "lite-xl/plugins/plugin2/" = { source = "<source2>/"; recursive = true; }
  #   "lite-xl/plugins/plugin3.lua" = { source = "<source3>"; }
  # }
  xdgEntries = mapAttrs' (name: source: (
    # Append a ".lua" if the plugin is a single file
    if (hasSuffix ".lua" source)
    then (nameValuePair "lite-xl/plugins/${name}.lua" { source = source; })
    else (nameValuePair "lite-xl/plugins/${name}" { source = source; recursive = true; })
  )) enablePlugins;
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
    ./evergreen
    ./formatter
    ./languages
    ./lsp
  ];

  config = mkIf cfg.enable {
    xdg.configFile = xdgEntries;
  };
}

