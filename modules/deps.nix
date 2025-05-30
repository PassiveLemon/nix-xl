{ lib, pkgs, ... }:
let
  inherit (lib) mapAttrs recursiveUpdate;

  # We need to fill in the attrset with dummy values for libraries and plugins that don't have deps
  supportedLibraries = import ./libraries/libraries.nix { inherit lib pkgs; };
  supportedPlugins = import ./plugins/plugins.nix { inherit lib pkgs; };

  templateLibraryDeps = mapAttrs (_name: _value: {
    libraries = [ ];
    plugins = [ ];
  }) supportedLibraries;
  templatePluginDeps = mapAttrs (_name: _value: {
    libraries = [ ];
    plugins = [ ];
  }) supportedPlugins;

in
{
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

