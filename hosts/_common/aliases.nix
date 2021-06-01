{
  environment.shellAliases = {
    mux = "tmuxinator";

    gpgkill = "gpgconf --kill gpg-agent";

    # ls -> exa
    ls = "exa -G  --color auto --icons -a -s type";
    ll = "exa -l -g --git --color always --icons -a -s type";

    # cat -> bat
    cat = "bat";
    catt = "bat --style=plain --pager=never";

    # Reload profile
    rel = ". ~/.zshrc";

    # Serve current dir
    srv = "python -m SimpleHTTPServer \${1:-8000}";

    #1 = "cd +1";
    #2 = "cd +2";
    #3 = "cd +3";
    #4 = "cd +4";
    #5 = "cd +5";
    #6 = "cd +6";
    #7 = "cd +7";
    #8 = "cd +8";
    #9 = "cd +9";
    _ = "sudo";
    ack = "nocorrect ack";
    b = "\${(z)BROWSER}";
    bower = "noglob bower";
    cd = "nocorrect cd";
    cp = "nocorrect cp -i";
    cpi = "nocorrect cp -i";
    d = "dirs -v";
    df = "df -kh";
    diffu = "diff --unified";
    e = "\${(z)VISUAL:-\${(z)EDITOR}}";
    ebuild = "nocorrect ebuild";
    fc = "noglob fc";
    find = "noglob find";
    ftp = "noglob ftp";
    heroku="nocorrect heroku";
    history="noglob history";
    history-stat="history 0 | awk ''{print $2}'' | sort | uniq -c | sort -n -r | head";
    http-serve="python3 -m http.server";
    lc="lt -c";
    lk = "ll -Sr";
    lm="la | \"$PAGER\"";
    ln = "nocorrect ln -i";
    lni="nocorrect ln -i";
    locate="noglob locate";
    lr = "ll -R";
    lt = "ll -tr";
    lu = "lt -u";
    lx = "ll -XB";
    man = "nocorrect man";
    mkdir = "nocorrect mkdir -p";
    mv = "nocorrect mv -i";
    mvi = "nocorrect mv -i";
    mysql = "nocorrect mysql";
    o = "open";
    p = "\${(z)PAGER}";
    pbc = "pbcopy";
    pbp="pbpaste";
    po="popd";
    pu="pushd";
    rake = "noglob rake";
    reset-yubikey = "gpg-connect-agent \"scd serialno\" \"learn --force\" /bye";
    rm = "nocorrect rm -i";
    rmi = "nocorrect rm -i";
    rsync = "noglob rsync";
    run-help="man";
    sa = "alias | grep -i";
    scp = "noglob scp";
    sftp = "noglob sftp";
    sl="ls";
    tmuxa = "tmux  new-session -A";
    tmuxl = "tmux list-sessions";
    topc = "top -o cpu";
    topm = "top -o vsize";
    type = "type -a";
    which-command= "whence";

  };
}
