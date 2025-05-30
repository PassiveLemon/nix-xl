{ pkgs, ... }:
let
  inherit (pkgs) fetchgit;
in
# TODO: We might be able to get these from lock.json

# Language structure
# "<lang>" = "<source>";
{
  "c" = fetchgit {
    url = "https://github.com/tree-sitter/tree-sitter-c";
    rev = "7fa1be1b694b6e763686793d97da01f36a0e5c12";
    hash = "sha256-gmzbdwvrKSo6C1fqTJFGxy8x0+T+vUTswm7F5sojzKc=";
  };
  "cpp" = fetchgit {
    url = "https://github.com/tree-sitter/tree-sitter-cpp";
    rev = "56455f4245baf4ea4e0881c5169de69d7edd5ae7";
    hash = "sha256-yU1bwDhwcqeKrho0bo4qclqDDm1EuZWHENI2PNYnxVs=";
  };
  "css" = fetchgit {
    url = "https://github.com/tree-sitter/tree-sitter-css";
    rev = "6e327db434fec0ee90f006697782e43ec855adf5";
    hash = "";
  };
  "d" = fetchgit {
    url = "https://github.com/gdamore/tree-sitter-d";
    rev = "45e5f1e9d6de2c68591bc8e5ec662cf18e950b4a";
    hash = "";
  };
  "ecma" = "";
  "go" = fetchgit {
    url = "https://github.com/tree-sitter/tree-sitter-go";
    rev = "5e73f476efafe5c768eda19bbe877f188ded6144";
    hash = "";
  };
  "gomod" = fetchgit {
    url = "https://github.com/camdencheek/tree-sitter-go-mod";
    rev = "6efb59652d30e0e9cd5f3b3a669afd6f1a926d3c";
    hash = "";
  };
  "gosum" = fetchgit {
    url = "https://github.com/amaanq/tree-sitter-go-sum";
    rev = "e2ac513b2240c7ff1069ae33b2df29ce90777c11";
    hash = "";
  };
  "html" = fetchgit {
    url = "https://github.com/tree-sitter/tree-sitter-html";
    rev = "cbb91a0ff3621245e890d1c50cc811bffb77a26b";
    hash = "sha256-lNMiSDAQ49QpeyD1RzkIIUeRWdp2Wrv6+XQZdZ40c1g=";
  };
  "html_tags" = "";
  "javascript" = fetchgit {
    url = "https://github.com/tree-sitter/tree-sitter-javascript";
    rev = "6fbef40512dcd9f0a61ce03a4c9ae7597b36ab5c";
    hash = "sha256-X9DDCBF+gQYL0syfqgKVFvzoy2tnBl+veaYi7bUuRms=";
  };
  "jsx" = "";
  "julia" = fetchgit {
    url = "https://github.com/tree-sitter/tree-sitter-julia";
    rev = "18b739c1563c83fc816170a4241adfa4b69e5c47";
    hash = "";
  };
  "lua" = fetchgit {
    url = "https://github.com/MunifTanjim/tree-sitter-lua";
    rev = "4fbec840c34149b7d5fe10097c93a320ee4af053";
    hash = "sha256-fO8XqlauYiPR0KaFzlAzvkrYXgEsiSzlB3xYzUpcbrs=";
  };
  "rust" = fetchgit {
    url = "https://github.com/tree-sitter/tree-sitter-rust";
    rev = "3691201b01cacb2f96ffca4c632c4e938bfacd88";
    hash = "";
  };
  "zig" = fetchgit {
    url = "https://github.com/maxxnino/tree-sitter-zig";
    rev = "a80a6e9be81b33b182ce6305ae4ea28e29211bd5";
    hash = "";
  };
}

