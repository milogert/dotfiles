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

    # REMOVE THESE ENVENTUALLY
    "node@14"
  ];

  homebrew.casks = [
    "1password"
    "alfred"
    "beekeeper-studio"
    "brave-browser"
    "cloudapp"
    "docker"
    "firefox-developer-edition"
    "google-chrome"
    "hammerspoon"
    "insomnia"
    "krisp"
    "muzzle"
    "notion"
    "openvpn-connect"
    "postgres"
    "slack"
    "spotify"
    "tuple"
    "zoom"
  ];

  homebrew.masApps = {
    Kindle = 405399194;
    Xcode = 497799835;
  };

  homebrew.extraConfig = ''
    cask_args appdir: "~/Applications"
  '';
}
