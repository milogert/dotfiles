{ pkgs, ... }:

rec {
  imports = [
    ./aliases.nix
    ./fonts.nix
  ];

  system.stateVersion = 4;

  nix.useSandbox = false;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = "experimental-features = nix-command flakes ca-references";
  nix.trustedUsers = [ "root" "@admin" ];

  nix.trustedBinaryCaches = [
    https://cache.nixos.org
    https://nix-community.cachix.org
    #https://rpearce.cachix.org
  ];

  nix.binaryCaches = nix.trustedBinaryCaches;

  nix.binaryCachePublicKeys = [
    cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
    nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
    #rpearce.cachix.org-1:JfcsbYqjrn4Hb3nbBnlprokdSEE5xYdxZ39ikK7nOCM=
  ];

  services.nix-daemon.enable = true;

  users.nix.configureBuildUsers = true;

  environment.shells = with pkgs; [
    zsh
    bashInteractive
  ];

  environment.variables = {
    EDITOR = "nvim";
    MANPAGER = "sh -c 'col -b | bat -l man -p'";
    NPM_TOKEN = "`cat $HOME/.npmrc 2>/dev/null | grep authToken | tr \"=\" \"\\n\" | tail -n 1`";
    PATH = builtins.concatStringsSep ":" [
      "/usr/local/sbin"
      "$HOME/.local/bin"
      "$HOME/.yarn/bin"
      "$PATH"
    ];
    RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
    SHELL = "${pkgs.zsh}/bin/zsh";
    TERM = "xterm-256color";
  };

  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    bash
    bash-completion
    bat
    browserpass
    cachix
    coreutils
    ctop
    diskonaut
    exa
    findutils
    fzf
    gitAndTools.delta
    gitAndTools.gh
    gnupg
    htop
    jq
    lazydocker
    ncdu
    neovim
    nix-prefetch-git
    pass
    procs # https://github.com/dalance/procs
    rename
    ripgrep
    shellcheck
    speedtest-cli
    starship
    tokei # https://github.com/XAMPPRocky/tokei
    tree
    zsh-autosuggestions
    zsh-completions
  ];

  programs.bash.enable = true;

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';
}
