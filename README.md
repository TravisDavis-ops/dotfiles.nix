![ nixos ](https://socialify.git.ci/TravisDavis-ops/dotfiles.nix/image?description=1&font=Source%20Code%20Pro&forks=1&issues=1&logo=https%3A%2F%2Ftdavis.dev%2Fnixoscolorful.svg&owner=1&pattern=Circuit%20Board&pulls=1&stargazers=1&theme=Light)

  The structure of this repository is meant to allow for simple system definitions,
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

| Configuration                       |  Domain          | Services   | Type      | Location    | Descriptions            | Role     | Status | Notes  |
| ----------------------------------- | ---------------- | ---------- | --------- | ----------- | ----------------------- | -------- | ------ | ------ |
| [Jade](./hosts/jade)                |                  |            | Cloud     | linode      | Services Hosting        | Hosting  | 🟢     |        |
|                                     | cloud.tdavis.dev | Nextcloud  |           |             | File Storage            | Service  | 🟢     | 1,2    |
|                                     | git.tdavis.dev   | Gitea      |           |             | Private Git             | Service  | 🟢     | 1      |
| [Azure](./hosts/azure)              | lab.tdavis.dev   |            | Cloud     | linode      | Cloud Testing           | Testing  | 🟢     |        |
| [Ruby](./hosts/ruby)                |                  |            | Desktop   | local       | Local Testing           | Hosting  | 🟢     | 3      |
|                                     | ruby:8080        | Pi-Hole    |           |             | DNS                     | Service  | 🟢     |        |
|                                     | ruby:8081        | Komga      |           |             | Manga Reader            | Service  | 🟢     |        |
|                                     | ruby:8082        | JellyFin   |           |             | Media Server            | Service  | 🟢     | 4      |
|                                     | ruby:8083        | Shoko      |           |             | Collection Tracker      | Service  | 🟢     | 3      |
| [Garnett](./hosts/garnett)          |                  |            | Laptop    | local       | *loaned out*            | Travel   | 🔴     | 2      |

# Host Notes
> 1. Backup not configured
> 2. Has performance problems
> 3. Slow shut down thanks to containers
> 4. No hardware acceleration

# Todo
- Setup nixos-generator to create an iso

## Thanks to theses projects
___for the in valuable guides and resourses I used to get this far___
- [NixOS Configuration  with Flakes](https://jdisaacs.com/blog/nixos-config)
- [Home-Manager](https://)


