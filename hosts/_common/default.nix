{ pkgs, ... }:

let
  substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://milogert.cachix.org"
  ];
in {
  imports = [
    ./aliases.nix
  ];

  nix = {
    settings = {
      sandbox = false;
      trusted-users = [ "root" "@admin" ];

      inherit substituters;
      trusted-substituters = substituters;
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "milogert.cachix.org-1:MaZAAWJXDV85HpLm2yyLX9b52wQghRxljAZJg0dEjkY="
      ];
    };

    # Garbage collection.
    gc.automatic = false;
    gc.options = "--delete-older-than 30d";

    # Which package set to use.
    package = pkgs.nixStable;

    extraOptions = "experimental-features = nix-command flakes";
  };

  environment.variables = {
    BAT_THEME = "srcery";
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    NPM_TOKEN = "`cat $HOME/.npmrc 2>/dev/null | grep npmjs | grep authToken | tr \"=\" \"\\n\" | tail -n 1`";
    PATH = builtins.concatStringsSep ":" [
      "/usr/local/sbin"
      "$HOME/.local/bin"
      "$HOME/.yarn/bin"
      "$PATH"
    ];
    # RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
    SHELL = "${pkgs.zsh}/bin/zsh";
    TERM = "xterm-256color";
  };

  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    bash
    bash-completion
    bat # Need this for aliases.
    cachix
    cargo
    coreutils # Why do I have this?
    ctop
    diskonaut
    exa
    fd
    findutils
    fswatch
    fzf # Need this for aliases.
    gcc
    gnumake
    gnupg
    go
    htop
    jq
    neofetch
    nix-prefetch-git
    # nixops
    neovim-custom
    openvpn
    postgresql
    python
    rename
    ripgrep
    shellcheck
    silver-searcher
    speedtest-cli
    starship # Need this for aliases.
    statix
    terraform
    tree
    unzip
    viddy
    wget
    yq
    zsh-autosuggestions
    zsh-completions
  ];

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    #gpg-connect-agent /bye
    gpg-connect-agent updatestartuptty /bye > /dev/null
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';
}
