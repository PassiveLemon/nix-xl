{ inputs, lib, pkgs, ... }:
let
  inherit (lib) genAttrs attrNames mergeAttrsList;

  # Languages in lite-xl-plugins
  lxlLanguageStrings = [
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
  ];

  # Lite-XL plugin languages prefix
  lxlpl = "${inputs.lite-xl-plugins}/plugins/language_";

  # Generate attrset of lang to paths
  # -> {
  #   lang1 = "path-to-lang1";
  #   lang2 = "path-to-lang2";
  #   lang3 = "path-to-lang3";
  # }
  lxlLanguages = genAttrs lxlLanguageStrings (lang: "${lxlpl}${lang}.lua");

  # Languages in external repositories
  externalLanguages = import ./externalLanguages.nix { inherit pkgs; };

  # Take the name of each language in externalLanguages and add those with lxlLanguageStrings
  languageStrings = lxlLanguageStrings ++ (attrNames externalLanguages);

  languages = mergeAttrsList [
    lxlLanguages
    externalLanguages
  ];
in
{
  supportedLanguageStrings = languageStrings;
  supportedLanguages = languages;
}

