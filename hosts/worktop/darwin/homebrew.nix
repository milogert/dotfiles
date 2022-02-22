{
  homebrew.enable = true;
  homebrew.autoUpdate = true;
  homebrew.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.noLock = true;

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
    "alacritty" # Removable, but drops back a few versions
    "beekeeper-studio"
    "cloudapp"
    "docker"
    "firefox-developer-edition"
    "flux"
    "google-chrome"
    "hammerspoon"
    "insomnia"
    "krisp"
    "love"
    "microsoft-edge"
    "muzzle"
    "notion"
    "openvpn-connect"
    "postgres"
    "slack"
    "spotify"
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
