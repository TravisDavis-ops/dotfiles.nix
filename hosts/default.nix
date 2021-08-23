{ nur, nix, builders, ... }: {

  ruby = import ./ruby { inherit nix nur builders; };
  garnet = import ./garnet { inherit nix nur builders; };
}
