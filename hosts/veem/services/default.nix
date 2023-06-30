{ pkgs, ... }:

{
  services = {
    avahi = {
      enable = true;
      openFirewall = true;
    };

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

    # Enable the OpenSSH daemon.
    openssh.enable = true;
    openssh.openFirewall = true;

    flatpak.enable = true;
  };
}
