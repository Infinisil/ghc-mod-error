{ pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/ca2ba44cab47767c8127d1c8633e2b581644eb8f.tar.gz";
    sha256 = "1jg7g6cfpw8qvma0y19kwyp549k1qyf11a5sg6hvn6awvmkny47v";
  }) {}
}:

let 
  hpkgs = pkgs.haskellPackages.extend (pkgs.haskell.lib.packageSourceOverrides {
    test = ./test;
  });


  # I thought these 2 were equivalent, but the first one fails, the second one doesn't
  # Error is "Got error while processing diagnostics: <command line>: cannot satisfy -package-id hnix-0.5.2-5hMz8sQY4ky2OCdjsvbD9J"
  failingEnv = hpkgs.shellFor {
    packages = p: [ p.test ];
  };

  workingEnv = hpkgs.test.env;

in
  workingEnv.overrideAttrs (old: {
    buildInputs = old.buildInputs or [] ++ [ hpkgs.cabal-install ];
  })
