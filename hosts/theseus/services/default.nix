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

    logind.settings.Login = ''
      HandlePowerKey=ignore
    '';

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    desktopManager.plasma6.enable = true;
    displayManager.defaultSession = "plasma";

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];

      # Enable the GNOME 3 Desktop Environment.
      # displayManager.gdm = {
      #   enable = true;
      #   wayland = true;
      # };
      # desktopManager.gnome = {
      #   enable = true;
      # };
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
