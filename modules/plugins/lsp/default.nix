{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption types attrNames mapAttrsToList optionalAttrs length flatten optional elem;
  inherit (lib) mkLuaScript; # Custom
  cfg = config.programs.lite-xl;

  # https://github.com/lite-xl/lite-xl-lsp/blob/master/config.lua
  serverAttrs = with pkgs; {
    "basedpyright" = basedpyright;
    "bash_ls" = bash-language-server;
    "ccls" = ccls;
    "clangd" = clang;
    "closure_lsp" = closure-lsp;
    "crystalline" = crystalline;
    "dartls" = dart;
    "deno_ls" = deno;
    "dockerfile_ls_nodejs" = dockerfile-language-server;
    "elixir_ls" = elixir-ls;
    # "elm_ls" = elm-language-server;
    "erlang_ls" = beam29Packages.erlang;
    "fennel_ls" = fennel-ls;
    "flow" = flow;
    "fort_ls" = fortls;
    "gleam_ls" = gleam;
    "glsl_analyzer" = glsl_analyzer;
    "gopls" = gopls;
    "groovy_ls" = groovy-language-server;
    "haskell_ls" = haskell-language-server;
    "intelephense" = intelephense;
    "jdtls" = jdt-language-server;
    "kotlin" = kotlin-language-server;
    "lemminx" = lemminx;
    "lua_ls" = lua-language-server;
    "marksman" = marksman;
    "metals" = metals;
    "nil_ls" = nil;
    "nimlsp" = nimlsp;
    # "ocaml_lsp" = ;
    "ols" = ols;
    "omnisharp" = omnisharp-roslyn;
    "perlnavigator" = perlnavigator;
    "pyright" = pyright;
    # "python_ls" = pylsp;
    "quick_lint_js" = quick-lint-js;
    "r_ls" = R;
    "ruby_ls" = ruby-lsp;
    "ruff" = ruff;
    "rust_analyzer" = rustup;
    "rust_ls" = rustup;
    "serve_d" = serve-d;
    "solargraph" = solargraph;
    # "sql_ls" = ;
    "svelte_ls" = svelte-language-server;
    "tailwind_css_ls" = tailwindcss-language-server;
    "taplo" = taplo;
    "texlab" = texlab;
    "tinymist" = tinymist;
    "typescript_ls" = typescript-language-server;
    # "typst_lsp" = ;
    # "v_analyzer" = ;
    # "v_ls" = ;
    "vala_ls" = vala-language-server;
    "vim_ls" = vim-language-server;
    "vscode_css_ls" = vscode-css-languageserver;
    # "vscode_html_ls" = vscode-html-languageserver;
    "vscode_json_ls" = vscode-json-languageserver;
    "yaml_ls" = yaml-language-server;
    "zls" = zls;
  };
  serverStrings = attrNames serverAttrs;

  enableList = cfg.plugins.lsp.enableList;

  concatServers = mkLuaScript enableList;

  # Generate a list (nested: [["1"] ["2"] ["3"]]) of packages
  genPackages = servers: (mapAttrsToList (name: value: optional (elem name enableList) value) servers);
in
{
  options = {
    programs.lite-xl.plugins.lsp = {
      enableList = mkOption {
        type = types.listOf (types.enum serverStrings);
        description = "The list of LSPs to enable.";
        default = [ ];
      };
      addPackages = mkEnableOption "adding language server packages";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = optionalAttrs (length enableList > 0) {
      "lite-xl/plugins/lsp_servers/init.lua" = {
        text = ''
          -- mod-version: 3
          local lspconfig = require("plugins.lsp.config")
          local servers = '${concatServers}'

          -- Match server strings in ",serv1,,serv2,,serv3,"
          for serv in servers:gmatch(",([%w_]+),") do
            lspconfig[serv].setup()
          end
        '';
      };
    };
    # Add language servers dynamically
    home.packages = flatten (optional cfg.plugins.lsp.addPackages [
      (genPackages serverAttrs)
    ]);
  };
}

