{ pkgs, lib, system, ... }@inputs:
let callPackage = lib.callPackageWith (pkgs // { inherit (lib) builders; });
in
{
  nhentai = callPackage ./nhentai { pythonPackages = pkgs.python39Packages; };
  mangodl = callPackage ./mangodl { };
  xxh = callPackage ./xxh { pythonPackages = pkgs.python39Packages; };
  cocogitto = callPackage ./cocogitto { };
  swayhide = callPackage ./swayhide { };
  swaync = callPackage ./swaync { };
  nwg-dock = callPackage ./nwg-dock { };

  one-step-from-eden = callPackage ./one-step-from-eden { };
  cultist-simulator = callPackage ./cultist-simulator { };
  kentucky-route-zero = callPackage ./kentucky-route-zero { };
  legend-of-grimrock = callPackage ./legend-of-grimrock { };
  megaquarium = callPackage ./megaquarium { };
  moonlighter = callPackage ./moonlighter { };
  orwell = callPackage ./orwell { };
  orwell-iis = callPackage ./orwell-iis { };
  outlast = callPackage ./outlast { };
  shenzhen-io = callPackage ./shenzhen-io { };
  slay-the-spire = callPackage ./slay-the-spire { };
  slime-rancher = callPackage ./slime-rancher { };
  stardew-valley = callPackage ./stardew-valley { };
  torchlight-2 = callPackage ./torchlight-2 { };
  #broken-sword-2 = callPackage ./broken-sword-2 { };
  dont-starve = callPackage ./dont-starve { };
  sunless-sea = callPackage ./sunless-sea { };
  huniecam-studio = callPackage ./huniecam-studio { };
  dodgeball-academia = callPackage ./dodgeball-academia { };
}

