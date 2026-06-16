# nix-xl
Declaratively configure Lite-XL languages, plugins, and libraries.

Nix-XL features automatic dependency resolution, which makes Lite-XL configuration as simple as possible for Nix users without the need for [lpm](https://github.com/lite-xl/lite-xl-plugin-manager).

This project is still fairly unfinished, see the TODO section for more information

# Features
Supports 100% of all included plugins and libraries in [lite-xl-plugins](https://github.com/lite-xl/lite-xl-plugins) and nearly all of the linked plugins and libraries.

Nix-XL also supports the plugin sets like LSP, languages, and formatters from lite-xl-plugins and Evergreen highlighters.

> [!NOTE]
> Not all features currently have their hashes set or dependencies configured. If you discover one, open an issue

# Usage
Nix-XL is currently only supported as a home-manager module. It will not work in a NixOS configuration.
The only architecture currently supported is `x86_64-linux`. Others may be supported in the future.

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
    inputs.nix-xl.homeModules.nix-xl
  ];
  
  programs.lite-xl = {
    enable = true;
    depRes = true;
  };
}
```

When a config module is enabled, it will add the specified plugins/libraries to your Lite-XL config directory (Usually `~/.config/lite-xl/`). Additionally, each modules will create lua files that automatically load the specified plugins if required.

Disabling `depRes` (enabled by default) will disable automatic dependency resolution for the whole configuration.

## Plugins
To enable plugins, use the plugin option:
```nix
# home.nix
{
  programs.lite-xl = {
    enable = true;
    plugins.enableList = [ "bracketmatch" "editorconfig" "gitdiff_highlight" "treeview-extender" ];
  };
}
```
- All available plugins are on the [official plugin repository](https://github.com/lite-xl/lite-xl-plugins?tab=readme-ov-file#plugins)
  - `ide_*` plugins are not included since they are all links to the same `ide` plugin.

Plugins are placed top-level in `~/.config/lite-xl/plugins/` and do not require a loading init.lua file as Lite-XL will attempt to load all top-level plugins in this location.

### Languages
To enable syntax highlighting for languages, use the language option:
```nix
# home.nix
{
  programs.lite-xl = {
    enable = true;
    plugins.languages.enableList = [ "nix" "yaml" "zig" ];
  };
}
```
- All available languages are on the [official plugin repository](https://github.com/lite-xl/lite-xl-plugins?tab=readme-ov-file#languages)

The languages are placed in `~/.config/lite-xl/plugins/languages/` and a subsequent init.lua file is also placed there to load the languages.

### LSP
LSP provides language server and linter support in the editor, enabling autocompletions, hover information, type checking, etc.

To enable it, use the option:
```nix
# home.nix
{
  programs.lite-xl = {
    enable = true;
    plugins.lsp = {
      enableList = [ "bashls" "sumneko_lua" ];
      addPackages = true;
    };
  };
}
```
- Supported LSPs can be found [here](https://github.com/lite-xl/lite-xl-lsp/blob/master/config.lua)

Enabling `addPackages` will add the appropriate language servers and linters (if `lintplus` is in the plugins enableList) to your `home.packages`.

When any item is added to enableList, the LSP plugin is automatically enabled. Currently there is no way to configure the LSPs.

The init.lua file to load the LSP configs is placed in `~/.config/lite-xl/plugins/lsp_servers`

### Formatter
Formatter provides formatting key bindings in the editor.

To enable it, use the option:
```nix
# home.nix
{
  programs.lite-xl = {
    enable = true;
    plugins.formatter = {
      enableList = [ "black" "luaformatter" ];
    };
  };
}
```
- Supported formatters can be found [here](https://github.com/vincens2005/lite-formatters/tree/master/modules)

When any item is added to enableList, the formatters plugin is automatically enabled.

The formatters are placed in `~/.config/lite-xl/plugins/formatters/` and a subsequent init.lua file is also placed there to load the formatters.

### Evergreen
[Evergreen](https://github.com/Evergreen-lxl/Evergreen.lxl) adds support for syntax highlighting with Treesitter. This allows for more intelligent highlighting, but the number of available [languages](https://github.com/Evergreen-lxl/evergreen-languages) is far lesser than Lite-XL regex-style highlighting.

To enable it, use the option:
```nix
# home.nix
{
  programs.lite-xl = {
    enable = true;
    plugins.evergreen = {
      enableList = [ "html" "lua" ];
      copyLanguages = false;
    };
  };
}
```
- Supported languages can be found [here](https://github.com/Evergreen-lxl/evergreen-languages)

Enabling `copyLanguages` will attempt to enable each Evergreen language in your Lite-XL languages.

When any item is added to enableList, the Evergreen plugin is automatically enabled. 

The languages are placed in `~/.config/lite-xl/plugins/evergreen_languages/` and a subsequent init.lua file is also placed there to enable the language configs.

## Libraries
To enable libraries, use the library option:
```nix
# home.nix
{
  programs.lite-xl = {
    enable = true;
    libraries.enableList = [ "font_symbols_nerdfont_mono_regular" "tree_sitter" "widget" ];
  };
}
```
- All available libraries are on the [official plugin repository](https://github.com/lite-xl/lite-xl-plugins?tab=readme-ov-file#libraries)

Libraries are only used if a plugin or another library depends on them so they do not need any sort of init.lua file.

## Fonts
To enable fonts, use the font options:
```nix
# home.nix
{
  programs.lite-xl = {
    enable = true;
    fonts = {
      enable = true;
      font = "FiraCodeNerdFont-Retina";
      codeFont = "FiraCodeNerdFontMono-Retina";
    };
  };
}
```
- Supported fonts can be found [here](https://github.com/PassiveLemon/nix-xl/blob/master/modules/fonts/fonts.nix)

Currently, fonts are not automatically loaded so you will still need to configure that yourself. They are found at `~/.config/lite-xl/fonts`.

## Customs
Each module provides a way to configure custom plugins, libraries, languages, fonts, etc.

Any custom will override the same name item in the enableList. For example: if `exterm` were in enableList and also enabled with a custom source, only the source from the custom will be placed in your Lite-XL plugins.

Customs also skip dependency resolution since the names are not fixed. Technically, dependency resolution can work for customs, but only if they share a name with a supported plugin. For example: The nerdicons plugin depends on the font_symbols_nerdfont_mono_regular library. If you were to just use a custom nerdicons plugin, the library would not get loaded. However if you also specify nerdicons in the normal enableList, the library will get loaded, but the custom nerdicons source is still used.

For modules that take an `enableList`, use the `customEnableList` option. Despite the name, it should not be a list, rather it should be an attr set in the following format:
```nix
# home.nix
{
  programs.lite-xl = {
    enable = true;
    plugins = {
      enableList = [ /* ... */ ];
      customEnableList = {
        "exterm" = <path/to/exterm.lua>;
        "nerdicons" = <path/to/nerdicons.lua>;
      };
    };
  };
}
```
- LSP is the only exception to this as the module can't enable a custom LSP config

Fonts specifically have custom prefixed options that override the normal config options:
```nix
# home.nix
{
  programs.lite-xl = {
    enable = true;
    fonts = {
      enable = true;
      customFont = <path/to/font.ttf>;
    };
  };
}
```
- Any extension is supported, but it needs to be supported by Lite-XL to actually work

Like with enableLists, the customFont will override the normal config option.

# Todo
Main:
- Config
  - [ ] Main init file
  - [ ] Load fonts and theme color file
  - [ ] Load extra config file for user specified lua configuration.
- Plugins
  - Lintplus module. In case the user only wants linting and not an entire language server from LSP. Supported linters [here](https://github.com/liquidev/lintplus/tree/master/linters)
    - If lintplus and LSP are enabled, LSP does automatically enables linters, though currently unsure if globally or by language
      - Make this configurable?
- LSP
  - Inherit lite-xl languages for LSP like with Evergreen. Would need a way to key language names to LSPs
- Libraries
  - Dep res does not catch libraries from exclusively resolved plugins (plugins not in enableList). I think a better approach would be to go over every enabled plugin/library, and for each resolved dep, resolve both plugin and library deps at the same time. Need to keep the resolved library and plugin lists separate somehow
    - This would also natively allow library with plugin dependencies, even though that is not implemented
- Fonts
  - [x] Defined fonts
  - [x] Custom fonts
  - [ ] Lua file to load fonts
    - Font size config option
- Packages
  - Build `nonicons`
  - Finish `www`

Other maybes:
- Figure out a better way to source versions than packing everything into one nvfetcher.toml. It just needs to avoid getting rate-limited
- Switch everything from fetchgit to fetchFromGitHub where applicable
- External generated documentation
- Specific plugin configuration, like for snippets
- Specific LSP configuration

