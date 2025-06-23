{ lib, pkgs, ... }:
let
  inherit (lib) getPackage;
  inherit (pkgs) stdenv;

  lxl = (getPackage "lite-xl-plugins" pkgs).src;

  # TODO: Build nonicons because it is not in Nixpkgs
  # https://github.com/ya2s/nonicons/
in
{
  "font_nonicons" = stdenv.mkDerivation {
    name = "nonicons";
    src = lxl;
    
    buildPhase = "";
    
    installPhase = ''
      runHook preInstall

      mkdir $out
      cp $src/plugins/font_nonicons.lua $out/init.lua

      runHook postInstall
    '';
  };
  "font_symbols_nerdfont_mono_regular" = stdenv.mkDerivation {
    name = "symbols_nerdfont_mono_regular";
    src = lxl;
    
    buildPhase = "";
    
    installPhase = ''
      runHook preInstall

      mkdir $out
      cp ${pkgs.nerd-fonts.symbols-only}/share/fonts/truetype/NerdFonts/Symbols/SymbolsNerdFontMono-Regular.ttf $out/
      cp $src/plugins/font_symbols_nerdfont_mono_regular.lua $out/init.lua

      runHook postInstall
    '';
  };
}

