let
  commonConfig = import ../../_common/darwin/homebrew.nix;
in
{

  homebrew = {
    enable = true;
    # enableZshIntegration = true;
    onActivation.cleanup = "zap";

    taps = commonConfig.taps;

    brews = commonConfig.brews;

    casks = [
      "1password"
      "MonitorControl"
      "docker"
      "logi-options+"
      "loom"
      "moom"
      "muzzle"
      "slack"
    ]
    ++ commonConfig.casks;

    masApps = commonConfig.masApps;

    extraConfig = commonConfig.extraConfig;
  };
}
