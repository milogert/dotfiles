{ pkgs, ... }:

rec {
  imports = [
    ./homelab
    ./rsnapshot.nix
  ];

  systemd.services.mount-pstore.enable = false;

  services = {
    xserver = {
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
          terminal='exec alacritty'

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

    gnome.core-utilities.enable = false;

    pipewire = {
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
    openssh.enable = true;
    openssh.openFirewall = true;

    flatpak.enable = true;

    nfs = {
      server = {
        enable = true;

        exports = ''
        /opt/k8s-data-nfs       192.168.50.208(rw,sync,no_subtree_check)
        '';
        # /opt/k8s-data-nfs       theseus(rw,sync,no_subtree_check) k8s-rpi-1(rw,sync,no_subtree_check) k8s-rpi-2(rw,sync,no_subtree_check)
      };
    };
  };
}
