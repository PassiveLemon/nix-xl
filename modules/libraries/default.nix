{ config, lib, ... }:
let
  inherit (lib) subImport genNamedPaths mkIf mkOption types attrNames;
  cfg = config.programs.lite-xl;

  enableLibraries = subImport ./pack.nix;
  supportedLibraries = subImport ./libraries.nix;
  libraryStrings = attrNames supportedLibraries;

  namedPaths = genNamedPaths "lite-xl/libraries/" enableLibraries;
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

