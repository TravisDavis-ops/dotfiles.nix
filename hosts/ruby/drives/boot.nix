{
  "/" = {
    label = "nixos";
    fsType = "ext4";
  };
  "/boot" = {
    label = "boot";
    fsType = "vfat";
  };
  "/home" = {
    label = "storage";
    fsType = "ext4";
  };
}
