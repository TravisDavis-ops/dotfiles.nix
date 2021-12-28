{ config, pkgs, lib, ... }:
with lib;
let cfg = config.os.p.qmk-rules;
in
{
  options.os.p.qmk-rules= { enable = mkEnableOption "Qmk udev rules"; };

  config = mkIf cfg.enable {
    services.udev = {
      extraRules = ''
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2fef", TAG+="uaccess"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff0", TAG+="uaccess"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff3", TAG+="uaccess"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", TAG+="uaccess"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff9", TAG+="uaccess"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ffa", TAG+="uaccess"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ffb", TAG+="uaccess"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1c11", ATTRS{idProduct}=="b007", TAG+="uaccess"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1eaf", ATTRS{idProduct}=="0003", TAG+="uaccess"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", TAG+="uaccess"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05df", TAG+="uaccess"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05dc", TAG+="uaccess"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="6124", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9203", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9205", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9207", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1ffb", ATTRS{idProduct}=="0101", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0036", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0037", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="000c", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="000d", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="000e", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2a03", ATTRS{idProduct}=="0036", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2a03", ATTRS{idProduct}=="0037", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
        KERNEL=="hidraw*",             MODE="0660",          GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"
         KERNEL=="event*",         NAME="input/%k",               MODE="660",  GROUP="input"
      '';
    };
  };
}
