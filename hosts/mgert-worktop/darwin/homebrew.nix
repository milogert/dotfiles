{
  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";

  homebrew.taps = [
    "homebrew/cask"
    "homebrew/cask-versions"
  ];

  homebrew.brews = [
    "gnu-sed"
    "openvpn"
    "pinentry-mac"
    "postgres"

    # Remove These Eventually.
    "node@14"
  ];

  homebrew.casks = [
    "1password"
    "beekeeper-studio"
    "brave-browser"
    "calibre"
    "clamxav"
    "cloudapp"
    #"docker" # Docker Desktop is not supported in homebrew currently.
    "google-chrome"
    "insomnia"
    "krisp"
    "muzzle"
    "notion"
    "openvpn-connect"
    "plex"
    "postgres-unofficial"
    "slack"
    "spotify"
    "zoom"
  ];

  homebrew.masApps = {
    Xcode = 497799835;
  };

  homebrew.extraConfig = ''
    cask_args appdir: "~/Applications"
  '';
}
