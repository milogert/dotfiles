# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/2b4c2544-8ae7-4d38-953e-b8624e58658b";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3435-DC21";
      fsType = "vfat";
    };

  swapDevices = [ ];

  hardware = {
    # high-resolution display
    # video.hidpi.enable = lib.mkDefault true;

    opengl = {
      # driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        #amdvlk
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
      # This is for steam support. Needs pipewire at the moment
      extraPackages32 = with pkgs.pkgsi686Linux; [
        #amdvlk
        # libva
      ] ++ lib.optionals config.services.pipewire.enable [ pipewire ];
    };

    pulseaudio = {
      enable = false;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
    };

    bluetooth = {
      enable = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
  };
}
