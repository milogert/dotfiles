{ pkgs
, config
, ...
}:

let
  tmuxPlugins = pkgs.tmuxPlugins // pkgs.callPackage ./custom-plugins.nix {};
in {
  home.file = {
    "${config.xdg.configHome}/tmuxinator/" = {
      recursive = true;
      source = ../../config/tmuxinator;
    };
  };

  programs.tmux = {
    enable = true;
    tmuxinator.enable = true;

    baseIndex = 1;
    # enableFzf = true;
    # enableMouse = true;
    keyMode = "vi";
    escapeTime = 1;
    historyLimit = 10000;
    terminal = "xterm-256color"; # screen-* or tmux-*
    plugins = with tmuxPlugins; [
      vim-tmux-navigator
      srcery-tmux
    ];
    extraConfig = ''
      # Mostly my own config but...
      # Tips from https://dev.to/iggredible/useful-tmux-configuration-examples-k3g

      set-option -sa terminal-overrides ',alacritty:RGB'

      # Rebind prefix key from C-b to C-Space
      set -g prefix C-Space
      unbind-key C-b
      bind-key C-Space send-prefix

      # Set the default shell.
      set-option -g default-shell ${pkgs.zsh}/bin/zsh
      set-option -ga terminal-overrides ",xterm-256color:Tc"

      # Swap layout switch and previous buffer keys.
      unbind Space
      bind Space last-window
      unbind b
      bind b next-layout

      # Force a reload of the config file
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf \; display "tmux config reloaded"

      # Set window notifications
      # setw -g monitor-activity on
      # set -g visual-activity on
      # set -g monitor-silence on

      # Start window numbering at 1 for easier switching.
      setw -g base-index 1
      setw -g pane-base-index 1
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      set -g renumber-windows on

      # Rejoin panes
      bind j choose-window 'join-pane -h -s "%%"'
      bind J choose-window 'join-pane -s "%%"'

      # Allow mousewheel scrolling.
      set-option -g mouse on
      #set -g mode-mouse on
      #set -g mouse-select-window on
      #set -g mouse-select-pane on
      unbind -T copy-mode-vi MouseDragEnd1Pane
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection

      # Focus last session when exiting a session totally.
      set-hook session-closed 'switch-client -l'

      ## Enable clipboard interactivity
      #set -g set-clipboard on

      ## Set window notifications
      #set -g monitor-activity on
      #set -g visual-activity on

      ## Update files on focus (using for neovim)
      set -g focus-events on

      ## macOS Command+K (Clear scrollback buffer)
      #bind -n C-k clear-history

      ## A quiter setup
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      ###########
      ## Status #
      ###########
      ## https://rudra.dev/posts/a-mininal-tmux-configuration-from-scratch/

      ## Set status bar on
      set -g status on

      ## Update the status line every second
      set -g status-interval 1

      ## Set the position of window lists.
      set -g status-justify left # [left | centre | right]

      ## Set Vi style keybinding in the status line
      set -g status-keys vi

      ## Set the status bar position
      set -g status-position top # [top, bottom]

      ## Set status bar background and foreground color.
      #set -g status-style fg=colour136,bg="#002b36"

      ## Set left side status bar length and style
      set -g status-left-length 60
      set -g status-left-style default

      ## Display the session name
      #set -g status-left "#[fg=green] ❐ #S #[default]"
      set -g status-left "#S@#H "

      ## Display the os version (Mac Os)
      #set -ag status-left " #[fg=black] #[fg=green,bright]  #(sw_vers -productVersion) #[default]"

      ## Display the battery percentage (Mac OS)

      ## Set right side status bar length and style
      set -g status-right-length 140
      set -g status-right-style default

      ## Display the cpu load (Mac OS)
      set -g status-right "#[fg=green,bg=default,bright]#(top -l 1 | grep -E "^CPU" | sed 's/.*://')#[default]"
      # set -g status-right "#(top -l 1 | grep -E "^CPU" | sed 's/.*:/  /') "

      # Battery.
      set -ag status-right "| #[fg=green,bg=default,bright]🔋 #(pmset -g batt | tail -1 | awk '{print $3}' | tr -d ';') #[default]"

      # Display the date
      set -ag status-right "| #[fg=white,bg=default]%a %d #[default]"

      # Display the time
      set -ag status-right "#[fg=colour172,bright,bg=default]%l:%M %p #[default]"

      ## Display the hostname
      #set -ag status-right "#[fg=cyan,bg=default] ☠ #H #[default]"
      #set -ag status-right " ☠ #H "

      # Marking Panes #########################################################

      bind \` switch-client -t'{marked}'
    '';
  };
}
