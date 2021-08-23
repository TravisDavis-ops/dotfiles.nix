{ nix, builders }@inputs:
let
  inherit (nix.lib) callPackageWith;
  callPackage = callPackageWith (nix.pkgs);
  self = with nix.pkgs;
    recurseIntoAttrs {
      nhentai = callPackage ./nhentai { pythonPackages = python3Packages; };
      cocogitto = callPackage ./cocogitto {};
      #toml-bombadil = callPackage ./toml-bombadil {};
      swayhide = callPackage ./swayhide { };
      corsair-pro-led = callPackage ./cosair-pro-led  { inherit fetchFromGitHub;  kernel = linuxPackages.kernel; };
      one-step-from-eden = callPackage
        (import ./one-step-from-eden {
          lib = nix.lib;
          inherit builders;
        })
        { };
      cultist-simulator = callPackage
        (import ./cultist-simulator {
          lib = nix.lib;
          inherit builders;
        })
        { };
      kentucky-route-zero = callPackage
        (import ./kentucky-route-zero {
          lib = nix.lib;
          inherit builders;
        })
        { };
      legend-of-grimrock = callPackage
        (import ./legend-of-grimrock {
          lib = nix.lib;
          inherit builders;
        })
        { };
      megaquarium = callPackage
        (import ./megaquarium {
          lib = nix.lib;
          inherit builders;
        })
        { };
      moonlighter = callPackage
        (import ./moonlighter {
          lib = nix.lib;
          inherit builders;
        })
        { };
      orwell = callPackage
        (import ./orwell {
          lib = nix.lib;
          inherit builders;
        })
        { };
      orwell-ignorance-is-strength = callPackage
        (import ./orwell-ignorance-is-strength {
          lib = nix.lib;
          inherit builders;
        })
        { };
      outlast = callPackage
        (import ./outlast {
          lib = nix.lib;
          inherit builders;
        })
        { };
      # shenzhen-io = callPackage (import ./shenzhen-io {  lib = nix.lib; inherit builders; }) {};
      # slay-the-spire = callPackage (import ./slay-the-spire {  lib = nix.lib; inherit builders; }) {};
      slime-rancher = callPackage
        (import ./slime-rancher {
          lib = nix.lib;
          inherit builders;
        })
        { };
      stardew-valley = callPackage
        (import ./stardew-valley {
          lib = nix.lib;
          inherit builders;
        })
        { };
      torchlight = callPackage
        (import ./torchlight {
          lib = nix.lib;
          inherit builders;
        })
        { };
    };
in
self

