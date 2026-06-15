{ lib, pkgs, ... }:
let
  inherit (lib) mapAttrs recursiveUpdate;

  # Plugins/libraries and their dependencies should be put here.

  # We need to fill in the attrset with dummy values for libraries and plugins that don't have deps due to how getDeps works
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
    colorpicker = {
      libraries = [ "widget" ];
    };
    evergreen = {
      libraries = [ "tree_sitter" ];
    };
    lsp = {
      libraries = [ "widget" ];
      plugins = [ "lintplus" "snippets" "lsp_snippets" ];
    };
    lsp_snippets = {
      libraries = [ "json" "widget" ];
      plugins = [ "snippets" ];
    };
    nerdicons = {
      libraries = [ "font_symbols_nerdfont_mono_regular" ];
    };
    snippets = {
      libraries = [ "json" ];
    };
  };
}

