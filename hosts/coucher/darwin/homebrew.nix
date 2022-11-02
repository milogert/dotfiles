{
  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";

  homebrew.taps = [
    "homebrew/cask"
    "homebrew/cask-versions"
  ];

  homebrew.brews = [
    "gnu-sed"
    "pinentry-mac"
    "postgres"
  ];

  homebrew.casks = [
    "beekeeper-studio"
    "calibre"
    "docker"
    "firefox-developer-edition"
    "google-chrome"
    "insomnia"
    "notion"
    "plex"
    "postgres-unofficial"
    "spotify"
  ];

  homebrew.masApps = {
    Xcode = 497799835;
  };

  homebrew.extraConfig = ''
    cask_args appdir: "~/Applications"
  '';
}
