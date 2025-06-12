{ pkgs, ... }:

# Font structure
# {
#   "<name>" = "<source>";
# }
{
  "FiraCodeNerdFont-Retina" = pkgs.nerd-fonts.fira-code + "/share/fonts/truetype/NerdFonts/FiraCode/FiraCodeNerdFont-Retina.ttf";
  "FiraCodeNerdFontMono-Retina" = pkgs.nerd-fonts.fira-code + "/share/fonts/truetype/NerdFonts/FiraCode/FiraCodeNerdFontMono-Retina.ttf";
}

