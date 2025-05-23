{ inputs, config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types attrNames getAttrs mapAttrs' nameValuePair;
  cfg = config.programs.lite-xl;

  supportedLibraries = import ./libraries.nix { inherit inputs lib pkgs; };
  libraryStrings = attrNames supportedLibraries;

  # Filter loaded libraries
  configLibraries = cfg.libraries;
  userLibraries = getAttrs configLibraries supportedLibraries;

  # Map supportedLibraries attrset to xdg.configFile entries
  # -> {
  #   "lite-xl/libraries/lib1/" = { source = "<source1>/"; recursive = true; }
  #   "lite-xl/libraries/lib2/" = { source = "<source2>/"; recursive = true; }
  #   "lite-xl/libraries/lib3/" = { source = "<source3>/"; recursive = true; }
  # }
  namedPaths = mapAttrs' (name: source:
    nameValuePair "lite-xl-test/libraries/${name}/" { source = source; recursive = true; })
    userLibraries;
in
{
  options = {
    programs.lite-xl = {
      libraries = mkOption {
        type = types.listOf (types.enum libraryStrings);
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = namedPaths;
  };
}

