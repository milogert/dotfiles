{
  environment.shellAliases = {
    boo = "echo BOO";
    cat = "bat";
    catt = "bat --style=plain --pager=never";
    gpgkill = "gpgconf --kill gpg-agent";
    ll = "exa -l -g --git --color always --icons -a -s type";
    ls = "exa -G --color auto --icons -a -s type";
    mux = "tmuxinator";
    rel = ". ~/.zshrc";
    reset-yubikey = "gpg-connect-agent \"scd serialno\" \"learn --force\" /bye";
    srv = "python -m SimpleHTTPServer \${1:-8000}";
  };
}
