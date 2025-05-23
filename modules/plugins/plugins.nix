{ inputs, lib, pkgs, ... }:
let
  inherit (lib) genAttrs mergeAttrsList;

  # Plugins in lite-xl-plugins
  lxlPluginStrings = [
    "align_carets"
    "autoinsert"
    "autosave"
    "autosaveonfocuslost"
    "autowrap"
    "bigclock"
    "bracketmatch"
    "centerdoc"
    "cleanstart"
    "colorpicker"
    "colorpreview"
    "copyfilelocation"
    "custom_caret"
    "datetimestamps"
    "dragdropselected"
    "ephemeral_tabs"
    "eval"
    "exec"
    "extend_selection_line"
    "fontconfig"
    "fontpreview"
    "force_syntax"
    "ghmarkdown"
    "gitopen"
    "gitstatus"
    "gofmt"
    "gui_filepicker"
    "indent_convert"
    "indentguide"
    "ipc"
    "keymap_export"
    "lfautoinsert"
    "linenumbers"
    "lite_debugger"
    "macmodkeys"
    "markers"
    "memoryusage"
    "minimap"
    "motiontrail" "navigate"
    "nerdicons"
    "nonicons"
    "opacity"
    "open_ext"
    "openfilelocation"
    "openselected"
    "pdfview"
    "primary_selection"
    "rainbowparen"
    "regexreplacepreview"
    "restoretabs"
    "scalestatus"
    "search_ui"
    "select_colorscheme"
    "selectionhighlight"
    "settings"
    "smallclock"
    "smartopenselected"
    "smoothcaret"
    "sort"
    "spellcheck"
    "sticky_scroll"
    "su_save"
    "svg_screenshot"
    "tab_switcher"
    "tabnumbers"
    "tetris"
    "texcompile"
    "titlesize"
    "togglesnakecamel"
    "typingspeed"
    "unboundedscroll"
    "wordcount"
  ];

  # Lite-XL plugin prefix
  lxlp = "${inputs.lite-xl-plugins}/plugins";

  # Generate attrset of plugin to source file
  # -> {
  #   plugin1 = "<source1>.lua";
  #   plugin2 = "<source2>.lua";
  #   plugin3 = "<source3>.lua";
  # }
  lxlPlugins = genAttrs lxlPluginStrings (plugin: "${lxlp}/${plugin}.lua");

  # Plugins in external repositories
  externalPlugins = import ./external.nix { inherit lib pkgs; };
in
# Plugin structure
# {
#   "<name>" = "<source>";
# }
mergeAttrsList [
  lxlPlugins
  externalPlugins
  {
    "editorconfig" = "${lxlp}/editorconfig";
    "profile" = "${lxlp}/profile";
  }
]

