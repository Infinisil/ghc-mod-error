{ pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/ca2ba44cab47767c8127d1c8633e2b581644eb8f.tar.gz";
    sha256 = "1jg7g6cfpw8qvma0y19kwyp549k1qyf11a5sg6hvn6awvmkny47v";
  }) {}
}:

let 
  hpkgs = pkgs.haskellPackages.extend (pkgs.haskell.lib.packageSourceOverrides {
    test = ./.;
  });

  hie-nix = import (fetchTarball {
    url = "https://github.com/domenkozar/hie-nix/archive/96af698f0cfefdb4c3375fc199374856b88978dc.tar.gz";
    sha256 = "1ar0h12ysh9wnkgnvhz891lvis6x9s8w3shaakfdkamxvji868qa";
  }) { inherit pkgs; };

in
  hpkgs.test.env.overrideAttrs (drv: {
    buildInputs = drv.buildInputs or [] ++ [ hpkgs.cabal-install hie-nix.hie84 ];
  })
