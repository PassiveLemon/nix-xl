{ inputs, config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types attrNames getAttrs concatMapStrings mapAttrs' nameValuePair mergeAttrsList;
  cfg = config.programs.lite-xl;

  supportedLanguages = import ./languages.nix { inherit inputs lib pkgs; };
  languageStrings = attrNames supportedLanguages;

  customLanguages = cfg.customLanguages;

  # Filter loaded languages
  configLanguages = cfg.languages;
  userLanguages = getAttrs configLanguages supportedLanguages;
  finalLanguages = mergeAttrsList [
    userLanguages customLanguages
  ];

  # Map supportedLanguages attrset to xdg.configFile entries
  # -> {
  #   "lite-xl/plugins/languages/language_lang1.lua" = { source = "<source1>"; }
  #   "lite-xl/plugins/languages/language_lang2.lua" = { source = "<source2>"; }
  #   "lite-xl/plugins/languages/language_lang3.lua" = { source = "<source3>"; }
  # }
  namedPaths = mapAttrs' (name: source:
    nameValuePair "lite-xl/plugins/languages/language_${name}.lua" { source = source; })
    finalLanguages;

  # Concat userLanguage list for lua script
  # -> ",lang1,,lang2,,lang3,"
  concatLanguages = concatMapStrings (lang: ",${lang},") configLanguages;
in
{
  options = {
    programs.lite-xl = {
      languages = mkOption {
        type = types.listOf (types.enum languageStrings);
        default = [ ];
      };
      customLanguages = mkOption {
        type = types.attrsOf types.path;
        default = { };
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = namedPaths // {
      # Script to load languages since they are not placed top-level
      "lite-xl/plugins/languages/init.lua" = {
        text = ''
          -- mod-version: 3

          local languages = '${concatLanguages}'

          -- Match language strings in ",lang1,,lang2,,lang3,"
          for lang in languages:gmatch(",([%w_]+),") do
            require("plugins.languages.language_" .. lang)
          end
        '';
      };
    };
  };
}

