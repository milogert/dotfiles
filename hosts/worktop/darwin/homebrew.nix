{
  homebrew.enable = true;
  homebrew.autoUpdate = false;
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
    "alfred"
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
