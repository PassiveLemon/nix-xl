{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mergeAttrsList;
  inherit (pkgs) fetchgit;

  pluginPackages = import ./pkgs {inherit lib pkgs;};
in
  # Plugins that are a single file should have the source set to the exact init.lua file
  # Plugins that are multiple files should have the source set to the root where init.lua is
  # Plugin structure
  # {
  #   "<name>" = "<source>";
  # }
  mergeAttrsList [
    pluginPackages
    {
      "base16" =
        (fetchgit {
          url = "https://github.com/SmileYzn/base16";
          rev = "ddb95c6ab1aacbc0353800642a7da0fd7011053c";
          hash = "sha256-gB2UTde7YotYqHR7N+sCaGyXrOQrcc5jNGHRK4KJQps=";
        })
        + "/plugins/base16/init.lua";
      "black" = fetchgit {
        url = "https://git.sr.ht/~tmpod/black-lite";
        rev = "2a1ab1b703f954edb39efb73e72b44c0d18b30a2";
        hash = "sha256-Oxmxe+MquqXOzZMdNZwnf2vFnYYI2u8bp/Hhk+fCh0s=";
      };
      "build" =
        (fetchgit {
          url = "https://github.com/lite-xl/lite-xl-ide";
          rev = "86060cbd391712cbcf55c29359ae4112fb8d8f02";
          hash = "sha256-T+FhzoNsD3t1DhOi7sovRjgMat+9rpRi/vz7SQcpm48=";
        })
        + "/plugins/build";
      "buffers" =
        (fetchgit {
          url = "https://codeberg.org/Mandarancio/lite-buffers";
          rev = "5f91642a337c35c9262726d363b1c6f15ba68f57";
          hash = "sha256-CUlwu5yC6sjUyxTuTLwl0lYv8W8uxmWiHylM4n+3260=";
        })
        + "/plugins/build";
      "code-plug" =
        (fetchgit {
          url = "https://github.com/chqs-git/code-plus";
          rev = "873dbc74d4ff5b858807686b8ee1c9c9182745e4";
          hash = "sha256-SKwvCdmCoAvRZroi5y4nNKsEBa9BLhI81STyP0rbjJc=";
        })
        + "/init.lua";
      "console" =
        (fetchgit {
          url = "https://github.com/lite-xl/console";
          rev = "57b186892f359e081efe0eea9a07326ddd5321b7";
          hash = "sha256-ihU5du2+oEoltcDey88yKWAZxELXMaOZg7xSddkFEls=";
        })
        + "/init.lua";
      "debugger" =
        (fetchgit {
          url = "https://github.com/lite-xl/lite-xl-ide";
          rev = "86060cbd391712cbcf55c29359ae4112fb8d8f02";
          hash = "sha256-T+FhzoNsD3t1DhOi7sovRjgMat+9rpRi/vz7SQcpm48=";
        })
        + "/plugins/debugger";
      "easingpreview" =
        (fetchgit {
          url = "https://github.com/thacuber2a03/lite-xl-easingpreview";
          rev = "a320c22303d53486f7b120ea3afc6a38ec35268d";
          hash = "sha256-rgQl7SBBdxAzq79Unj+FuQ+dg23Ve6RGe5L1nvlBbU0=";
        })
        + "/easingpreview.lua";
      "encoding" =
        (fetchgit {
          url = "https://github.com/jgmdev/lite-xl-encoding";
          rev = "16e2477e916f52e18f6d63f5ac61ace58b0c5e45";
          hash = "sha256-mTo61YaS8WbAyewvtz8WV2IJHWry2VJ+GTyfavRhYMY=";
        })
        + "/plugins/encodings.lua";
      "endwise" = fetchgit {
        url = "https://github.com/LolsonX/endwise-lite-xl";
        rev = "b3d7576edfe87cf7fe4af923c9a591250744760e";
        hash = "sha256-0y/SStBFNv6h5iAqTpJFkIp02FcvWnQHSjoY8TygA1c=";
      };
      # The old repository in which this was hosted at, https://github.com/bokunodev/lite_modules
      # has been removed so an archive was found on the Wayback Machine
      "eofnewline" = ./eofnewline.lua;
      "equationgrapher" =
        (fetchgit {
          url = "https://github.com/thacuber2a03/equationgrapher";
          rev = "11eaf773ab2747947e81e6d404a6f497a77e3490";
          hash = "sha256-VyUv6ezoplu/E5KJWQ0obhWoEj6DUE8bodo64/2nJM8=";
        })
        + "/equationgrapher.lua";
      "evergreen" = fetchgit {
        url = "https://github.com/Evergreen-lxl/Evergreen.lxl";
        rev = "7856f897c044e86ab93e27a60e9da8f490a47e4e";
        hash = "sha256-CwLMTSXVnYIYeRF6iOWSewTT7Ydk4t8zhaEQWT94Ih8=";
      };
      "exterm" =
        (fetchgit {
          url = "https://github.com/ShadiestGoat/lite-xl-exterm";
          rev = "aca8827fc1af831890cffd3dd122debac72429c6";
          hash = "sha256-/FTh5j39Jijd2UqqA98Dy8PQNnls8vcW6q5G60rvvOg=";
        })
        + "/exterm.lua";
      "findfileimproved" =
        (fetchgit {
          url = "https://github.com/jgmdev/lite-xl-threads";
          rev = "c182db7ad82d6ca4b1a8840609d093e6d3cbc89a";
          hash = "sha256-iAIJhNe/oli+DBZSGJLOCcRpOtmuWeV+unq4U2PK8a4=";
        })
        + "/plugins/findfileimproved.lua";
      "formatter" =
        (fetchgit {
          url = "https://github.com/vincens2005/lite-formatters";
          rev = "9ec4ee7f650e7daf84ba5f733f4e9ec5899100ec";
          hash = "sha256-/VBs3UWh298g15tku/hfsLGCXzfNMDKpATJ8I/frlw4=";
        })
        + "/formatter.lua";
      "gitblame" = fetchgit {
        url = "https://github.com/juliardi/lite-xl-gitblame";
        rev = "922d6961ee87990c92adb8bc89d1ce18fe8e2ee0";
        hash = "sha256-1/2FAsCH/qJP7LV5bnLkcTpRzAYhF/QEvzjuZJDOdsc=";
      };
      "gitdiff_highlight" = fetchgit {
        url = "https://github.com/vincens2005/lite-xl-gitdiff-highlight";
        rev = "f0e02b6a7299acbeb4a5f137b26830a6cca96cc8";
        hash = "sha256-qeBy4+7l+YM0buAWYQZOvhco6f3kwKuQxuh1dUBXX74=";
      };
      "keyhud" =
        (fetchgit {
          url = "https://codeberg.org/Mandarancio/keyhud";
          rev = "77c95fed9756b0b20a78ca0f61f20b593787bf20";
          hash = "sha256-gvXjo6rzMdnIGFta9bR8CU8I2F231RfW/hZaKmLSZu0=";
        })
        + "/init.lua";
      "kinc-projects" =
        (fetchgit {
          url = "https://github.com/Kode-Community/kinc_plugin";
          rev = "309fe4193a09cf739ed0a058b1a6966a463a1dbd";
          hash = "sha256-nJwGnZxYODzKt3CnOjqsPnGVIdfcOGNuie1NDbTbERc=";
        })
        + "/init.lua";
      "lintplus" = fetchgit {
        url = "https://github.com/liquidev/lintplus";
        rev = "eaff3321f569e89aca57e76dc1f684a37aecd254";
        hash = "sha256-T2wSWGqhagyEGEws7B2zIg1rv1DhcZvUjy54NZfRlqE=";
      };
      "litemark" =
        (fetchgit {
          url = "https://github.com/Quillwyrm/LiteMark";
          rev = "a0eb7de1bb3b7c8f9e2e266054a170e0cbedf4f7";
          hash = "sha256-8Ai3t8LClDDdr7xmxAmL5eBxEt9I68ij4YTB+tknawI=";
        })
        + "/litemark";
      "lite-xl-vibe" = fetchgit {
        url = "https://github.com/eugenpt/lite-xl-vibe";
        rev = "5b5579ab5efe9388c495d5b8baa6cd10b2db53ac";
        hash = "sha256-JSTYmfiy0BeBCVXxOLkXf9SaxPTWrsAam2ZQKn0hk4M=";
      };
      "lorem" =
        (fetchgit {
          url = "https://github.com/sheetcoder/lorem";
          rev = "b2da386519850d6f91ef67097e50141b3b11a90e";
          hash = "sha256-oX0trNEsN+5+4QU4L8rVJszt3/50zZOChMAMJO9IXm8=";
        })
        + "/lorem.lua";
      "lsp" = fetchgit {
        url = "https://github.com/lite-xl/lite-xl-lsp";
        rev = "61b51893c4b97cdb1950b333a98a0f9020bb530f";
        hash = "sha256-7RAHTPBHDNEH/gAUfiFnjwfjo799A6ykcDOyCiQvI0w=";
      };
      "lspkind" = fetchgit {
        url = "https://github.com/sammy-ette/lite-xl-lspkind";
        rev = "8fb5bb0947c96f04ab0430fc02bf081946bfb92e";
        hash = "sha256-F3zN7ge9VhlXjWjYd7ljXSVooHuhn1528FdGPnQgEPs=";
      };
      "modal" = fetchgit {
        url = "https://codeberg.org/Mandarancio/lite-modal";
        rev = "cba946509cde63ce97cb80d756219ba335c205b8";
        hash = "sha256-w2jD5+8Yuu4aZg8H+r/lewPlxJ1URHPnzPJiV+58rSg=";
      };
      "previewer" = fetchgit {
        url = "https://codeberg.org/Mandarancio/lite-previewer";
        rev = "6b4c5fb7518fdd691b652657b30f0d5f7337029b";
        hash = "sha256-is8U4n5rmqIsJOKQjDuLBwfR9S0n1c3xVKislXxjZB0=";
      };
      "projectsearch" =
        (fetchgit {
          url = "https://github.com/jgmdev/lite-xl-threads";
          rev = "c182db7ad82d6ca4b1a8840609d093e6d3cbc89a";
          hash = "sha256-iAIJhNe/oli+DBZSGJLOCcRpOtmuWeV+unq4U2PK8a4=";
        })
        + "/plugins/projectsearch.lua";
      "ptm" = fetchgit {
        url = "https://github.com/PerilousBooklet/lite-xl-ptm";
        rev = "cf197ff8336c40c58c5c19eeb73fb67603a0bc13";
        hash = "sha256-eJVjNwKtiK7rkOWZseBqn55O4qvLBZlIkFf/8XK6xec=";
      };
      "renamer" =
        (fetchgit {
          url = "https://github.com/Guldoman/lite-xl-renamer";
          rev = "49dfdcd8951b22f44515f0e9b70489e750b1c4a2";
          hash = "sha256-gryBypyYraOjZn+Tx0zwmxA06LjW5cgRBZbpHIxSZgs=";
        })
        + "/renamer.lua";
      "scm" = fetchgit {
        url = "https://github.com/lite-xl/lite-xl-scm";
        rev = "1bb4cfce305ea17769c95672e0a441e7b6e66c6f";
        hash = "sha256-acIa7NY/LdFyiVF8sh5Fj+tKquJhexUM+n26opCoURo=";
      };
      "snippets" =
        (fetchgit {
          url = "https://github.com/vqns/lite-xl-snippets";
          rev = "87248a23c8ceb2507f46b3ca3689b32d35c9c709";
          hash = "sha256-FSZTm5bpQKUfPsjwmat9NVrQg9HWil9kFWiBFFnEWJA=";
        })
        + "/snippets.lua";
      "lsp_snippets" =
        (fetchgit {
          url = "https://github.com/vqns/lite-xl-snippets";
          rev = "87248a23c8ceb2507f46b3ca3689b32d35c9c709";
          hash = "sha256-FSZTm5bpQKUfPsjwmat9NVrQg9HWil9kFWiBFFnEWJA=";
        })
        + "/lsp_snippets.lua";
      "sortcss" =
        (fetchgit {
          url = "https://github.com/felixsanz/lite-xl-sortcss";
          rev = "ee4552148b38663e24dedcf4bc80ba8221dd54e0";
          hash = "sha256-uZroMCyIXm42bxTc3MCb3CCthDtws+YvdipR8YUTt3M=";
        })
        + "/init.lua";
      "theme16" = fetchgit {
        url = "https://github.com/monolifed/theme16";
        rev = "c39b33cb318d4baa2b4b9cc6e6370cb3ede3ef22";
        hash = "sha256-pNg8KEwpeP0f0ezDTNyshb8S0VkZBLjlrJAiLgEdVZQ=";
      };
      "todotreeview" =
        (fetchgit {
          url = "https://github.com/drmargarido/TodoTreeView";
          rev = "0b3937a0f0d761843df9b71cfea35884e839348b";
          hash = "sha256-vlzuCl7Fqs9iLBhz5qPf4tqe4DtRU5AxTfQpvjpQZNo=";
        })
        + "/todotreeview-xl.lua";
      "treeview-extender" = fetchgit {
        url = "https://github.com/juliardi/lite-xl-treeview-extender";
        rev = "6163ffb90a8187c8ee1bd24a7da5b6145b06d2e8";
        hash = "sha256-87tS3XRgXWYkiaAE13wazoFWezcX96DQp+8xKjBvgR4=";
      };
      "updatechecker" = fetchgit {
        url = "https://github.com/vincens2005/lite-xl-updatechecker";
        rev = "3478abd43618da857d4315bcc8fddf08c27e1150";
        hash = "sha256-+XEML//ZDWybp6nbKJ1QRRu9WimQx7QUkcRbXdnZpHA=";
      };
      "visu" =
        (fetchgit {
          url = "https://github.com/sammy-ette/Visu";
          rev = "782c7b1ebde38dad2c3c6a1c1dee6761230dea16";
          hash = "sha256-vd/EYX0s8RFMsf+Kd32ctgOXVnaFzrm+m6hPh+qLgQw=";
        })
        + "/init.lua";
      "wal" =
        (fetchgit {
          url = "https://github.com/thacuber2a03/wal.lxl";
          rev = "f8face57597c2f2ead26473bb6212896d3a30caa";
          hash = "sha256-xXublc9yH+B1PL+wbmPndAK79Ye+PBtOVeLU3FylBk8=";
        })
        + "/init.lua";
    }
  ]
