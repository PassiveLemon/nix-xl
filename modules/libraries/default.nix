{ inputs, config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types getAttrs mapAttrs' nameValuePair;
  cfg = config.programs.lite-xl;

  librariesImport = import ./libraries.nix { inherit inputs lib pkgs; };

  supportedLibraryStrings = librariesImport.supportedLibraryStrings;
  supportedLibraries = librariesImport.supportedLibraries;

  # User config specified libraries
  configLibraries = cfg.libraries;
  userLibraries = getAttrs configLibraries supportedLibraries;

  # Map supportedLibraries attrset to xdg.configFile entries
  # -> {
  #   "lite-xl/libraries/lib1/" = { source = "path-to-lib1/"; }
  #   "lite-xl/libraries/lib2/" = { source = "path-to-lib2/"; }
  #   "lite-xl/libraries/lib3/" = { source = "path-to-lib3/"; }
  # }
  namedPaths = mapAttrs' (name: source:
    nameValuePair "lite-xl-test/libraries/${name}/" { source = source; recursive = true; })
    userLibraries;
in
{
  options = {
    programs.lite-xl = {
      libraries = mkOption {
        type = types.listOf (types.enum supportedLibraryStrings);
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    _debug = namedPaths;
    xdg.configFile = namedPaths;
  };
}

