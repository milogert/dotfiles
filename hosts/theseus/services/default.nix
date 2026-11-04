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

    logind.settings.Login = {
      HandlePowerKey = "ignore";
    };

    displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        cursor.size = 24;
        keyboard.layout = "us";
      };
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
      };
    };

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };

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
