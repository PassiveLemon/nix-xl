{ lib, pkgs, ... }:
let
  inherit (lib) genAttrs mergeAttrsList;
  inherit (pkgs) fetchgit;

  lxl = fetchgit {
    url = "https://github.com/lite-xl/lite-xl-plugins";
    rev = "499961ac9d08c803c814244e36b2174e9494b532";
    hash = "sha256-hhohhW2kC8oBTk3RYW/V9rFzgSJJqseUkDApHv+oBsY=";
  };

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

  # Lite-XL languages prefix
  lxlpl = "${lxl}/plugins/language_";

  # Generate attrset of lang to source file
  # -> {
  #   lang1 = "<source1>.lua";
  #   lang2 = "<source2>.lua";
  #   lang3 = "<source3>.lua";
  # }
  lxlLanguages = genAttrs lxlLanguageStrings (lang: "${lxlpl}${lang}.lua");

  # Languages in external repositories
  externalLanguages = import ./external.nix { inherit pkgs; };
in
# Language structure
# {
#   "<name>" = "<source>";
# }
mergeAttrsList [
  lxlLanguages
  externalLanguages
]

