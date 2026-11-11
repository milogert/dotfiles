{ ... }:

{
  programs.noctalia = {
    enable = true;

    recommendedServices.enable = true;

    # enable `launch_apps_as_systemd_service`, whatever that means.
    systemd.enable = true;

  };

  programs.umbriel = {
    enable = true;
    };
}
