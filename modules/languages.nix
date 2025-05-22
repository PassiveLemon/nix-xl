{ inputs, config, lib, ... }:
let
  inherit (lib) mkIf mkOption types concatMapStrings genAttrs mapAttrs' nameValuePair;
  cfg = config.programs.lite-xl;

  supportedLanguages = [
    # Languages in lite-xl-plugins
    "angelscript" "assembly_riscv" "assembly_x86" "autohotkey_v1" "awk" "batch" "bazel"
    "bend" "bib" "blade" "blueprint" "brainfuck" "buzz" "c7" "caddyfile" "carbon"
    "clojure" "cmake" "csharp" "cue" "d" "dart" "diff" "edp" "ejs" "elixir" "elm" "env"
    "erb" "fe" "fennel" "fortran" "fstab" "gabc" "gdscript" "glsl" "gmi" "go" "graphql"
    "gravity" "groovy" "hare" "haxe" "hlsl" "hs" "htaccess" "ignore" "ini" "java" "jiyu"
    "json" "jsx" "julia" "kdl" "kotlin" "lilypond" "liquid" "lobster" "lox" "make"
    "marte" "meson" "miniscript" "moon" "nelua" "nginx" "nim" "nix" "objc" "odin"
    "openscad" "perl" "php" "pico8" "pkgbuild" "po" "powershell" "psql" "R" "rescript"
    "ring" "rivet" "ruby" "rust" "sass" "scala" "sh" "ssh_config" "st" "swift" "tal"
    "tcl" "teal" "tex" "toml" "ts" "tsx" "typst" "umka" "v" "wren" "yaml" "zig"
    # Languages in external repos
    # TBA
  ];

  # User specified languages
  languages = cfg.languages;

  # Concat language list for lua script
  # -> ",lang1,,lang2,,lang3,"
  concatLanguages = concatMapStrings (lang: ",${lang},") languages;

  # Lite-XL plugin languages prefix
  lxlpl = "${inputs.lite-xl-plugins}/plugins/language_";

  # Generate attrset of lang to paths
  # -> {
  #   lang1 = "path-to-lang1";
  #   lang2 = "path-to-lang2";
  #   lang3 = "path-to-lang3";
  # }
  languageFiles = genAttrs languages (lang: "${lxlpl}${lang}.lua");

  # Map languageFiles attrset to xdg.configFile entries
  # -> {
  #   "lite-xl/languages/language_lang1.lua" = { source = "path-to-lang1"; }
  #   "lite-xl/languages/language_lang2.lua" = { source = "path-to-lang2"; }
  #   "lite-xl/languages/language_lang3.lua" = { source = "path-to-lang3"; }
  # }
  namedPaths = mapAttrs' (name: source:
    nameValuePair "lite-xl-test/languages/languages_${name}.lua" { source = source; })
    languageFiles;
in
{
  options = {
    programs.lite-xl = {
      languages = mkOption {
        type = types.listOf (types.enum supportedLanguages);
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
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

