{ config, lib, pkgs, ... }:
let
  inherit (lib) genNamedPaths mkIf mkOption types attrNames;
  cfg = config.programs.lite-xl;

  enableLibraries = import ./pack.nix { inherit config lib pkgs; };
  supportedLibraries = import ./libraries.nix { inherit lib pkgs; };
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

