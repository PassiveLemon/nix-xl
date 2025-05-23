{ buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "litepresence1";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "sammy-ette";
    repo = "litepresence";
    rev = "v${version}";
    hash = "sha256-x3kGkPGXEjjo+PKMevqJyeuIRIzgw8XRfQr4spTeFkE=";
  };

  vendorHash = "sha256-KP+QhFB1djgb3/URfGrfdZ9ZfAnv3ETyaV8Gtru1DZw=";

  postInstall = ''
    cp $src/init.lua $out/init.lua
    mv $out/bin/litepresence $out/litepresence
  '';
}

