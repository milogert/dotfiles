{
  homebrew.enable = true;
  homebrew.autoUpdate = true;
  homebrew.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.noLock = true;

  homebrew.taps = [
    "homebrew/cask"
    #"homebrew/cask-fonts"
    "homebrew/cask-versions"
  ];

  homebrew.brews = [
    "awscli"
    "mas"
    "openvpn"
    "postgres"
    "gnupg@2.2"
    #"zsh-completions"
    "tmuxinator"
    "pinentry-mac"
    "gnu-sed"

    # REMOVE THESE ENVENTUALLY
    #"neovim"
    #"ripgrep"
    #"starship"
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
    #"psequel"
    #"postman"
    "slack"
    "spotify"
    #"tableplus"
    #"virtualbox"
    #"virtualbox-extension-pack"
    #"visual-studio-code"
    "zoom"
    "1password"
    "postgres"
    "microsoft-edge"
    "cloudapp"
    #"font-hack-nerd-font"
  ];

  homebrew.masApps = {
    #"1Password" = 1333542190;
    #Hush = 1544743900;
    #"Just Focus" = 1142151959;
    Kindle = 405399194;
    #Medis = 1063631769;
    Xcode = 497799835;
  };

  homebrew.extraConfig = ''
    cask_args appdir: "~/Applications"
  '';
}
