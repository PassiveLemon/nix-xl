{ lib, pkgs, ... }:
let
  inherit (lib) getPackage genAttrs mergeAttrsList;

  lxl = (getPackage "lite-xl-plugins" pkgs).src;

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
    "lite-debugger"
    "macmodkeys"
    "markers"
    "memoryusage"
    "minimap"
    "motiontrail"
    "navigate"
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

  # Generate attrset of plugin to source file
  # -> {
  #   plugin1 = "<source1>.lua";
  #   plugin2 = "<source2>.lua";
  #   plugin3 = "<source3>.lua";
  # }
  lxlPlugins = genAttrs lxlPluginStrings (plugin: "${lxl}/plugins/${plugin}.lua");

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
  # Plugins that are not just one file
  {
    "editorconfig" = "${lxl}/plugins/editorconfig";
    "profile" = "${lxl}/plugins/profile";
  }
]

