# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, nixpkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  systemd.services.mount-pstore.enable = false;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    videoDrivers = [ "amdgpu" ];

    # Enable the GNOME 3 Desktop Environment.
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome = {
      enable = true;

       extraGSettingsOverrides = ''
        # Change default background
        [org.gnome.desktop.default-applications]
        terminal='exec kitty'

        # Favorite apps in gnome-shell
        [org.gnome.shell]
        favorite-apps=['org.gnome.Photos.desktop', 'org.gnome.Nautilus.desktop']
      '';

      extraGSettingsOverridePackages = [
        pkgs.gsettings-desktop-schemas # for org.gnome.desktop
        pkgs.gnome.gnome-shell # for org.gnome.shell
      ];
    };
  };
  services.gnome.core-utilities.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}

