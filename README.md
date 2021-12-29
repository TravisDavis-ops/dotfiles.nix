![ nixos ] (https://socialify.git.ci/TravisDavis-ops/dotfiles.nix/image?description=1&font=Source%20Code%20Pro&forks=1&issues=1&logo=https%3A%2F%2Ftdavis.dev%2Fnixoscolorful.svg&owner=1&pattern=Circuit%20Board&pulls=1&stargazers=1&theme=Light)

  The
  structure
  of
  this
  repository
  is
  meant
  to
  allow
  for
  simple
  system
  definitions,
constant deployments and uninform system configurations across my development machinces.
Individual hosts are defined in /hosts/

# Installation
Get the latest NixOs 21.11 [here](), mount your partitions (root must be mounted at `/mnt` ).
Download with `git clone`, and define your host useing `libs.mkHostSystem`

# Inital Setup ( If using existing host )
```
nix-shell -p nixFlakes git
git clone ...
nixos-install --flake ...#host
```

## Defining Host
The repository uses the function in lib.builders  called mkHostSystem. most of witch just pass info to the underlaying nixos module.
initrdModules, kernelModules, kernelPackages, bootloader, filesystem, drives, network are all given by `nixos-generate-config`.
To create a selekelion use `nix flake init -t ...#host `iside your diretory in hosts

# Current Hosts

| Configuration                       | Local Dns        | Type      | Location    | Description  | Role     | Status |
| ----------------------------------- | ---------------- | --------- | ----------- | ------------ | -------- | ------ |
| [Jade](./hosts/jade)                | cloud.tdavis.dev | Server    | linode      | Nextcloud    | Services | 🟢     |
|                                     | git.tdavis.dev   |           |             | Gitea        |          |        |
| [Azure](./hosts/azure)              | lab.tdavis.dev   | Server    | linode      | Test Server  | Testing  | 🟢     |
| [Ruby](./hosts/ruby)                | home.tdavis.dev  | Desktop   | local       | Desktop      | Primary  | 🟢     |
| [Garnett](./hosts/garnett)          |                  | Laptop    | local       | Netbook      | Travel   | 🔴     |






