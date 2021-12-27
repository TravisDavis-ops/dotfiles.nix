{ system, nixpkgs, home-manager, nur, ... }@inputs: rec {

  callPackageWith = set: p: overrides: import p (set // overrides);
  /* Return a Package called with arguments

    Example:
    set = { a= 0; b = 1;};
    overrides = {a = 1; b=2;};
    p = {a, b}: a+b;
    callPackageWith set p {};
    => 1
    callPackageWith set p overrides;
    => 3
  */
  callProfileWith = set: host: name: overrides: ({ ${name} = import ../hosts/${host}/profiles/${name}.nix set // overrides; });

  callProfile = host: name: ({ ${name} = import ../hosts/${host}/profiles/${name}.nix; });
  /* Return an AttrSet of Profiles

    Example:
    host = "nixos";
    name = "user";
    callProfile host name;
    => { user = import ../hosts/nixos/profiles/user.nix}
  */

  reduce = with nixpkgs.lib; (f: list: (foldl f (head list) (tail list)));
  /* apply a function of shape (cs: c: (...)) to cumulatively to a list
    Example:
    f = (cs: c: c // cs);
    list = [{a = 0} {b = 2}]
    reduce f list
    => {a = 0; b=2}
  */

  reduceToAttr = reduce (cs: c: c // cs);

  builders = callPackageWith inputs ./builders { inherit callProfileWith reduceToAttr callPackageWith callProfile builders; };
}
