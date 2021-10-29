{ pkgs, ... }:

rec {
  imports = [
    ./aliases.nix
  ];

  nix.useSandbox = false;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = "experimental-features = nix-command flakes ca-references";
  nix.trustedUsers = [ "root" "@admin" ];

  nix.trustedBinaryCaches = [
    https://cache.nixos.org
    https://nix-community.cachix.org
    https://milogert.cachix.org
  ];

  nix.binaryCaches = nix.trustedBinaryCaches;

  nix.binaryCachePublicKeys = [
    cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
    nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
    milogert.cachix.org-1:MaZAAWJXDV85HpLm2yyLX9b52wQghRxljAZJg0dEjkY=
  ];

  environment.variables = {
    BAT_THEME = "srcery";
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    NPM_TOKEN = "`cat $HOME/.npmrc 2>/dev/null | grep authToken | tr \"=\" \"\\n\" | tail -n 1`";
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


  environment.shellAliases = {
    adj = "echo ADJACENT";
  };
  environment.systemPackages = with pkgs; 
  let
    my-python-packages = python-packages: with python-packages; [
      pip
      #virutalenv
    ];
    python-with-packages = python38.withPackages my-python-packages;
  in [
    ag
    bash
    bash-completion
    bat # Need this for aliases.
    cachix
    cargo
    coreutils
    ctop
    diskonaut
    exa
    findutils
    fzf # Need this for aliases.
    gcc
    gnumake
    gnupg
    htop
    jq
    lazydocker
    ncdu
    nix-prefetch-git
    # nixops
    neovim # Need this for aliases.
    procs # https://github.com/dalance/procs
    python-with-packages
    rename
    ripgrep
    rnix-lsp
    shellcheck
    speedtest-cli
    starship # Need this for aliases.
    tree
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
