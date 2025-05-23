# nix-xl

Declaratively configure Lite-XL languages, plugins, and libraries.

This attempts to make Lite-XL configuration as easy and simple as possible and automatically includes dependencies.

> ![NOTE]
> I have not tested every single language, plugin, and library combination so there may be incompatibilities, missing features, or other issues.

The only included features are currently from [lite-xl-plugins](https://github.com/lite-xl/lite-xl-plugins). Any additions must have their own repository.
The only architecture currently supported is `x86_64-linux`. Others may be supported in the future.

# Usage
Nix-XL is currently only supported as a home-manager module. It will not work in a NixOS configuration.

Add the flake to your inputs:
```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-xl.url = "github:passivelemon/nix-xl";
  };

  outputs = { ... } @ inputs: {
    # ...
  };
}
```

Import the module and enable it:
```nix
# home.nix
{
  imports = [
    inputs.nix-xl.homeManagerModules.nix-xl
  ];
  
  programs.lite-xl = {
    enable = true;
  };
}
```

## Languages
To enable syntax highlighting for languages, use the language option:
```nix
# home.nix
{
  programs.lite-xl = {
    enable = true;
    languages = [ "nix" "yaml" "zig" ];
  };
}
```
- All available languages are on the [official plugin repository](https://github.com/lite-xl/lite-xl-plugins?tab=readme-ov-file#languages) with the following notes:
  - The language name is simply just everything after `language_`

## Plugins
To enable plugins, use the plugin option:
```nix
# home.nix
{
  programs.lite-xl = {
    enable = true;
    plugins = [ "bracketmatch" "editorconfig" "gitdiff_highlight" "treeview_extender" ];
  };
}
```
- Plugins with library or other plugin dependencies will have their dependencies automatically enabled.
- All available plugins are on the [official plugin repository](https://github.com/lite-xl/lite-xl-plugins?tab=readme-ov-file#plugins) with the following notes:
  - Plugin names are as they appear in the repository but all dashes are underscores. (discord-presence -> discord_presence)
  - `ide_*` and `lsp_*` packages are not individually included. (These currently aren't even implemented yet. See TODO.)

## Libraries
To enable plugins, use the plugin option:
```nix
# home.nix
{
  programs.lite-xl = {
    enable = true;
    libraries = [ "font_symbols_nerdfont_mono_regular" "tree_sitter" "widget" ];
  };
}
```
- Libraries will automatically be enabled for plugins that depend on them.
- All available libraries are on the [official plugin repository](https://github.com/lite-xl/lite-xl-plugins?tab=readme-ov-file#libraries) with the following notes:
  - Library names are exactly as they appear in the repository.
  - `golang haxe jdk nodejs` are not included as they are only for the lsp plugin and will be included when necessary. (These currently aren't even implemented yet. See TODO.)

# Todo
Core:
- [x] Implement languages
  - [x] Put them into their own `/plugins/languages` directory and create a lua file to require them
  - [x] External repo languages
  - [x] Custom languages

- [x] Implement libraries
  - [x] Most libraries require some package building so we need some derivations
  - [x] External repo libraries
  - [x] Custom libraries

- [x] Implement plugins
  - [x] External repo plugins
  - [x] Custom plugins
  - [x] Automatic library dependencies (Implemented, but not set up for everything)

Plugins:
- [ ] Evergreen
  - [ ] Need to build the shared objects so we need some derivations
  - [ ] Put Evergreen highlights into their own `/plugins/evergreen_languages` directory and create a lua file to require them (Similar to languages)
  - [ ] Custom languages
  - [ ] Inherit syntax languages

- [ ] LSP
  - Library deps `golang haxe jdk nodejs`
  - [ ] Put lsp into their own `/plugins/lsp_languages` directory and create a lua file to require them (Similar to languages)
  - [ ] Custom formats
  - [ ] Inherit syntax languages

- [ ] Formatter
  - [ ] Put formats into their own `/plugins/formatter_languages` directory and create a lua file to require them (Similar to languages)
  - [ ] Custom formats
  - [ ] Inherit syntax languages

General:
- [ ] nvfetcher to update plugin versions. Check every couple days or so since plugins aren't updated too frequently
- [ ] Config/init declaration

Later:
- Fix up "lite-xl-test" path to "lite-xl". Currently present in languages/default.nix, libraries/default.nix, plugins/default.nix
- Package meta attrs
- Descriptions on module options
- Switch everything from fetchgit to fetchFromGitHub (if applicable)
- `nonicons` (TODO: Build nonicons because it is not in Nixpkgs)
- `www` (TODO: Finish the package. Currently can't be built)

