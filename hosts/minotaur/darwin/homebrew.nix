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
      "discord"
    ]
    ++ commonConfig.casks;

    masApps = commonConfig.masApps;

    extraConfig = commonConfig.extraConfig;
  };
}
