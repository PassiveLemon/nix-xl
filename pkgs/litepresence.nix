{ version
, src
, buildGoModule
}:
buildGoModule {
  pname = "litepresence1";
  inherit version src;

  vendorHash = "sha256-KP+QhFB1djgb3/URfGrfdZ9ZfAnv3ETyaV8Gtru1DZw=";

  postInstall = ''
    cp $src/init.lua $out/init.lua
    mv $out/bin/litepresence $out/litepresence
  '';
}

