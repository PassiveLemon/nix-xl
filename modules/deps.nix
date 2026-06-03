{ lib, pkgs, ... }:
let
  inherit (lib) mapAttrs recursiveUpdate;

  # Plugins/libraries and their dependencies should be put here.
  # Specific dependency resolution needs should be implemented in its own plugin/library directory.

  # We need to fill in the attrset with dummy values for libraries and plugins that don't have deps
  supportedLibraries = import ./libraries/libraries.nix { inherit lib pkgs; };
  supportedPlugins = import ./plugins/plugins.nix { inherit lib pkgs; };

  templateLibraryDeps = mapAttrs (_: _: {
    libraries = [ ];
    plugins = [ ];
  }) supportedLibraries;
  templatePluginDeps = mapAttrs (_: _: {
    libraries = [ ];
    plugins = [ ];
  }) supportedPlugins;
in
{
  # Currently no supported library has dependencies
  libraries = templateLibraryDeps;
  plugins = recursiveUpdate templatePluginDeps {
    # Snippets
    lsp_snippets = {
      libraries = [ "json" ];
      plugins = [ "snippets" ];
    };

    # LSP
    emmet = {
      libraries = [ "nodejs" ];
      plugins = [ "lsp" ];
    };
    go = {
      libraries = [ "golang" ];
      plugins = [ "lsp" ];
    };
    haxe = {
      libraries = [ "haxe" "nodejs" ];
      plugins = [ "lsp" ];
    };
    java = {
      libraries = [ "jdk" ];
      plugins = [ "lsp" ];
    };
    json = {
      libraries = [ "nodejs" ];
      plugins = [ "lsp" ];
    };
    python = {
      libraries = [ "nodejs" ];
      plugins = [ "lsp" ];
    };
    typescript = {
      libraries = [ "nodejs" ];
      plugins = [ "lsp" ];
    };
    yaml = {
      libraries = [ "nodejs" ];
      plugins = [ "lsp" ];
    };
  };
}

