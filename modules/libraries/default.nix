{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types attrNames getAttrs mapAttrs' hasSuffix nameValuePair mergeAttrsList;
  cfg = config.programs.lite-xl;

  supportedLibraries = import ./libraries.nix { inherit config lib pkgs; };
  libraryStrings = attrNames supportedLibraries;

  customLibraries = import ./custom.nix { inherit config lib pkgs; };

  # Filter loaded libraries
  configLibraries = cfg.libraries.enableList;
  userLibraries = getAttrs configLibraries supportedLibraries;
  finalLibraries = mergeAttrsList [ userLibraries customLibraries ];

  # Map supportedLibraries attrset to xdg.configFile entries
  # -> {
  #   "lite-xl/libraries/lib1/" = { source = "<source1>/"; recursive = true; }
  #   "lite-xl/libraries/lib2/" = { source = "<source2>/"; recursive = true; }
  #   "lite-xl/libraries/lib3.lua" = { source = "<source3>"; }
  # }
  namedPaths = mapAttrs' (name: source: (
    # Append a ".lua" if the library is a single file
    if (hasSuffix ".lua" source)
    then (nameValuePair "lite-xl/libraries/${name}.lua" { source = source; })
    else (nameValuePair "lite-xl/libraries/${name}" { source = source; recursive = true; })
  )) finalLibraries;
in
{
  options = {
    programs.lite-xl.libraries = {
      enableList = mkOption {
        type = types.listOf (types.enum libraryStrings);
        default = [ ];
      };
      customEnableList = mkOption {
        type = types.attrsOf types.path;
        default = { };
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = namedPaths;
  };
}

