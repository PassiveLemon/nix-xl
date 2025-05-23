{ inputs, config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types attrNames getAttrs mapAttrs' hasSuffix nameValuePair;
  cfg = config.programs.lite-xl;

  supportedPlugins = import ./plugins.nix { inherit inputs lib pkgs; };
  pluginStrings = attrNames supportedPlugins;

  # Filter loaded plugins
  configPlugins = cfg.plugins;
  userPlugins = getAttrs configPlugins supportedPlugins;

  # Map supportedPlugins attrset to xdg.configFile entries
  # -> {
  #   "lite-xl/plugins/plugin1/" = { source = "<source1>/"; recursive = true; }
  #   "lite-xl/plugins/plugin2/" = { source = "<source2>/"; recursive = true; }
  #   "lite-xl/plugins/plugin3.lua" = { source = "<source3>"; }
  # }
  namedPaths = mapAttrs' (name: source: (
      # Append a ".lua" if the plugin is a single file
      if (hasSuffix ".lua" source)
      then (nameValuePair "lite-xl-test/plugins/${name}.lua" { source = source; })
      else (nameValuePair "lite-xl-test/plugins/${name}"  { source = source; recursive = true; })
    ))
    userPlugins;
in
{
  options = {
    programs.lite-xl = {
      plugins = mkOption {
        type = types.listOf (types.enum pluginStrings);
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = namedPaths;
  };
}

