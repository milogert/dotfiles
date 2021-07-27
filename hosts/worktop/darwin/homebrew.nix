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
    "awscli"
    "gnu-sed"
    "gnupg@2.2"
    "mas"
    "openvpn"
    "pinentry-mac"
    "postgres"
    #"zsh-completions"

    # REMOVE THESE ENVENTUALLY
    "node@14"
  ];

  homebrew.casks = [
    "1password"
    "alacritty"
    "cloudapp"
    "docker"
    "firefox-developer-edition"
    "flux"
    "google-chrome"
    "insomnia"
    "joplin"
    "krisp"
    "microsoft-edge"
    "muzzle"
    "postgres"
    "postico"
    "slack"
    "spotify"
    "zoom"
    #"deckset"
    #"font-hack-nerd-font"
    #"font-lilex"
    #"oversight"
    #"pgadmin4"
  ];

  homebrew.masApps = {
    Kindle = 405399194;
    Xcode = 497799835;
    "Typewriter for Markdown" = 1556419263;
  };

  homebrew.extraConfig = ''
    cask_args appdir: "~/Applications"
  '';
}
