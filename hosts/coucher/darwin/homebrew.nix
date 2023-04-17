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
    "google-chrome"
    "insomnia"
    "notion"
    "plex"
    "pocket-casts"
    "postgres-unofficial"
  ];

  homebrew.masApps = {
    Xcode = 497799835;
  };

  homebrew.extraConfig = ''
    cask_args appdir: "~/Applications"
  '';
}
