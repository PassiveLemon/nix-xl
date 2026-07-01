{ pkgs, ... }: with pkgs; {
  # https://github.com/liquidev/lintplus/tree/master/linters
  "cppcheck" = cppcheck;
  "luacheck" = lua54Packages.luacheck;
  "moonscript" = lua54Packages.moonscript;
  "nelua" = nelua;
  "nim" = nim;
  "php" = php;
  "python" = python312Packages.flake8;
  "rust" = cargo;
  "shellcheck" = shellcheck;
  "teal" = lua54Packages.tl;
  "typescript" = eslint;
  "v" = vlang;
  "zig" = zig;
}

