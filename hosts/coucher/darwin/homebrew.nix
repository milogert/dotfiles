{
  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";

  homebrew.taps = [
    "homebrew/cask"
    "homebrew/cask-versions"
  ];

  homebrew.brews = [
    "ios-deploy"
    "pinentry-mac"
  ];

  homebrew.casks = [
    "beekeeper-studio"
    "calibre"
    "discord"
    "docker"
    "flipper"
    "google-chrome"
    "insomnia"
    "notion"
    "plex"
    "pocket-casts"
    "postgres-unofficial"
  ];

  homebrew.masApps = {
    "1Blocker" = 1365531024;
    ColorSlurp = 1287239339;
    Xcode = 497799835;
  };

  homebrew.extraConfig = ''
    cask_args appdir: "~/Applications"
  '';
}
