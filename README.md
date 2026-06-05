# nix-xl
Declaratively configure Lite-XL languages, plugins, and libraries.

Nix-XL features automatic dependency resolution, which makes Lite-XL configuration as simple as possible for Nix users without the need for [lpm](https://github.com/lite-xl/lite-xl-plugin-manager).

# Features
Supports 100% of all included plugins and libraries in [lite-xl-plugins](https://github.com/lite-xl/lite-xl-plugins) and nearly all of the linked plugins and libraries.

Nix-XL also supports the plugin sets like lsp, languages, and formatters from lite-xl-plugins and Evergreen highlighters.

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

Disabling `depRes` will disable automatic dependency resolution for the whole configuration.

## Languages
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

`evergreen` still needs to be added to the plugins enableList to get loaded.

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

### LSP
LSP provides language server and linter support in the editor, providing support for autocompletions, type checking, etc.

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

`lsp` still needs to be added to the plugins enableList to get loaded.

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

# Todo
Fonts:
- [x] Defined fonts
- [x] Custom fonts
- [ ] Lua file to load fonts
- [ ] Font size option

Config:
- Create an init.lua file that should load the fonts, themes and other config files.
  - ? "User" specific configs, like a specific module option for use across home-manager configs that share a common plugin config but need some host specific config

Documentation:
- [x] Descriptions on module options
- [ ] Contributing guidelines/template
- [ ] Docs for main features, customs, plugin sets, etc
  - Ideally generated
  - Include how Customs overwrite

Todo:
- Turn Evergreen patches into patchfiles
- Build `nonicons`
- Finish `www`

Maybes:
- Figure out a better way to source versions than packing everything into one nvfetcher.toml. It just needs to avoid getting rate-limited
- Switch everything from fetchgit to fetchFromGitHub where applicable
- Custom themes. I am not creating a theme designer
- Inherit languages for LSP like with Evergreen. Would need a way to key language names to LSPs

