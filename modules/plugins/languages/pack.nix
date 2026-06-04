{ lib, ... }:
let
  inherit (lib) genPluginPaths subImport;

  # lite-xl-plugins
  languageNames = [
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

  languagePaths = genPluginPaths "${lib.NXLPkgs.lxp}/plugins/language_" languageNames [ ] (subImport ./external.nix);
in
languagePaths

