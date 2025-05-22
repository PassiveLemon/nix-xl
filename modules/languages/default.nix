{ inputs, config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types getAttrs concatMapStrings mapAttrs' nameValuePair;
  cfg = config.programs.lite-xl;

  languagesImport = import ./languages.nix { inherit inputs lib pkgs; };

  supportedLanguageStrings = languagesImport.supportedLanguageStrings;
  supportedLanguages = languagesImport.supportedLanguages;

  # User config specified languages
  configLanguages = cfg.languages;
  userLanguages = getAttrs configLanguages supportedLanguages;

  # Concat userLanguage list for lua script
  # -> ",lang1,,lang2,,lang3,"
  concatLanguages = concatMapStrings (lang: ",${lang},") configLanguages;

  # Map supportedLanguages attrset to xdg.configFile entries
  # -> {
  #   "lite-xl/languages/language_lang1.lua" = { source = "path-to-lang1"; }
  #   "lite-xl/languages/language_lang2.lua" = { source = "path-to-lang2"; }
  #   "lite-xl/languages/language_lang3.lua" = { source = "path-to-lang3"; }
  # }
  namedPaths = mapAttrs' (name: source:
    nameValuePair "lite-xl-test/languages/languages_${name}.lua" { source = source; })
    userLanguages;
in
{
  options = {
    programs.lite-xl = {
      languages = mkOption {
        type = types.listOf (types.enum supportedLanguageStrings);
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    _debug = namedPaths;
    xdg.configFile = namedPaths // {
      # Script to load languages since they are not placed top-level
      "lite-xl-test/languages/init.lua" = {
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

