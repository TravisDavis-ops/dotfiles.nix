{ lib, git, installShellFiles, makeWrapper, rustPlatform, fetchFromGitHub, ... }:
rustPlatform.buildRustPackage rec {
  pname = "cocogitto";
  version = "4.0.1";
  src = fetchFromGitHub {
    owner = "oknozor";
    repo = pname;
    rev = version;
    sha256 = "sha256-uSKzHo1lEBiXsi1rOKvfD2zVlkAUVZ5k0y8iiTXYE2A=";
  };
  cargoLock = {
    lockFile = ./Cargo.lock;
  };
  nativeBuildInputs = [ installShellFiles makeWrapper git ];

  doCheck = false;
  preCheck = ''
    export HOME="$(mktemp -d)"
    export CARGO_MANIFEST_DIR=$HOME
    ${git}/bin/git config --global user.name John
    ${git}/bin/git config --global user.email john@localhost
    ${git}/bin/git config --global init.defaultBranch master
    ${git}/bin/git config --global pull.rebase false
    cp $source $HOME/;
    cd $HOME/$source;
  '';

  postInstall = ''
    installShellCompletion --cmd cog \
      --bash <($out/bin/cog generate-completions bash) \
      --fish <($out/bin/cog generate-completions fish) \
      --zsh  <($out/bin/cog generate-completions zsh)

    wrapProgram $out/bin/cog \
      --prefix PATH : "${lib.makeBinPath [ git ]}"
    wrapProgram $out/bin/coco \
      --prefix PATH : "${lib.makeBinPath [ git ]}"
  '';

  meta = with lib; {
    description =
      "Cocogitto is a set of cli tools for the conventional commit and semver specifications.";
    homepage = "https://github.com/oknozor/cocogitto.git";
    license = licenses.mit;
    maintainers = [ ];
  };
}
