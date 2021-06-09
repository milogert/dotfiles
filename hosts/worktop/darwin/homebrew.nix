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
    "mas"
    "openvpn"
    "postgres"
    "gnupg@2.2"
    #"zsh-completions"
    "pinentry-mac"
    "gnu-sed"

    # REMOVE THESE ENVENTUALLY
    "node@14"
  ];

  homebrew.casks = [
    #"deckset"
    "alacritty"
    "docker"
    "firefox-developer-edition"
    "flux"
    "joplin"
    #"font-hack-nerd-font"
    #"font-lilex"
    "google-chrome"
    "insomnia"
    #"oversight"
    #"pgadmin4"
    "postico"
    "slack"
    "spotify"
    "zoom"
    "1password"
    "postgres"
    "microsoft-edge"
    "cloudapp"
  ];

  homebrew.masApps = {
    Kindle = 405399194;
    Xcode = 497799835;
  };

  homebrew.extraConfig = ''
    cask_args appdir: "~/Applications"
  '';
}
