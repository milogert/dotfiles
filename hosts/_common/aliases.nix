{
  environment.shellAliases = {
    cat = "bat";
    catt = "bat --style=plain --pager=never";
    gpgkill = "gpgconf --kill gpg-agent";
    ll = "exa -l -g --git --color always --icons -a -s type";
    ls = "exa --color auto --icons -a -s type";
    mux = "tmuxinator";
    rel = ". ~/.zshrc";
    reset-yubikey = "gpg-connect-agent \"scd serialno\" \"learn --force\" /bye";
    srv = "python -m SimpleHTTPServer \${1:-8000}";

    # Nix stuff.
    ns = "nix-shell ";
    nsp = "nix-shell -p ";

    nq = "nix search ";
    nqn = "nix search nixpkgs ";

    nm = "man 5 configuration.nix";
    nmh = "man 5 home-configuration.nix";

    ngit = "f() { nix-prefetch-git --quiet $1 | jq -r 'with_entries(select([.key] | inside([\"rev\", \"sha256\"])))'; }; f ";
  };
}
