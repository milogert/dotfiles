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
    "1password"
    "beekeeper-studio"
    "calibre"
    "cloudapp"
    "cyberduck"
    # "docker" # Docker Desktop is not supported in homebrew currently.
    "flipper"
    "google-chrome"
    "insomnia"
    "krisp"
    "muzzle"
    "notion"
    "openvpn-connect"
    "plex"
    "pocket-casts"
    "postgres-unofficial"
    "slack"
    "vyprvpn"
    "zoom"
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
