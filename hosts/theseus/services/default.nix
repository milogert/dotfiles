{ pkgs, ... }:

{
  systemd.services.mount-pstore.enable = false;

  virtualisation.docker.enable = true;
  services = {
    blueman.enable = true;

    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
        foomatic-filters
        brlaser
        cups-brother-hll2340dw
      ];
    };

    avahi = {
      enable = true;
      openFirewall = true;
    };

    xserver = {
      enable = true;

      # videoDrivers = [ "modesetting" ];

      # Enable the GNOME 3 Desktop Environment.
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome = {
        enable = true;

         /* extraGSettingsOverrides = '' */
         /*  # Favorite apps in gnome-shell */
         /*  [org.gnome.shell] */
         /*  favorite-apps=['org.gnome.Photos.desktop', 'org.gnome.Nautilus.desktop'] */
        /* ''; */

        /* extraGSettingsOverridePackages = [ */
         /*  pkgs.gsettings-desktop-schemas # for org.gnome.desktop */
         /*  pkgs.gnome.gnome-shell # for org.gnome.shell */
        /* ]; */
      };
    };

    gnome.core-utilities.enable = false;

    # Enable the OpenSSH daemon.
    openssh.enable = true;
    openssh.openFirewall = true;

    flatpak.enable = true;

    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };
  };
}
