{
  programs.tmux.enable = true;
  programs.tmux.enableSensible = true;
  programs.tmux.enableMouse = true;
  programs.tmux.enableFzf = true;
  programs.tmux.enableVim = true;
  programs.tmux.extraConfig = ''
# Set correct binding to Ctrl-a
#unbind C-b
#set -g prefix C-a

# Set the defualt shell.
set-option -g default-shell /bin/zsh
set-option -ga terminal-overrides ",xterm-256color:Tc"

# Force a reload of the config file
unbind r
bind r source-file ~/.tmux.conf \; display "tmux config reloaded :)"

setw -g mode-keys vi

# Quick pane cycling
unbind ^A
bind ^A select-pane -t :.+

# No delays
set -s escape-time 1

# Set window notifications
setw -g monitor-activity on
set -g visual-activity on

# Start window numbering at 1 for easier switching.
set -g base-index 1
setw -g pane-base-index 1
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# Allow mousewheel scrolling.
set-option -g mouse on
#set -g mode-mouse on
#set -g mouse-select-window on
#set -g mouse-select-pane on
unbind -T copy-mode-vi MouseDragEnd1Pane
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection

# Focus events
set -g focus-events

# Focus last session when exiting a session totally.
set-hook session-closed 'switch-client -l'

# Ressurection strategy
#set -g @resurrect-strategy-nvim 'session'

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'srcery-colors/srcery-tmux'
set -g @plugin 'christoomey/vim-tmux-navigator'
#set -g @plugin 'tmux-plugins/tmux-resurrect'
#set -g @plugin 'tmux-plugins/tmux-continuum'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'git@github.com/user/plugin'
# set -g @plugin 'git@bitbucket.com/user/plugin'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run -b '~/.tmux/plugins/tpm/tpm'

    # Rebind prefix key from C-b to C-Space
    #set -g prefix C-Space
    #unbind-key C-b
    #bind-key C-Space send-prefix

    ## Hot-reload tmux when configuration changes
    #bind r source-file /etc/tmux.conf\; display "Reloaded."

    ## Set history length
    #set -g history-limit 10000

    ## Enable clipboard interactivity
    #set -g set-clipboard on

    ## Set window notifications
    #set -g monitor-activity on
    #set -g visual-activity on

    ## Update files on focus (using for neovim)
    #set -g focus-events on

    ## macOS Command+K (Clear scrollback buffer)
    #bind -n C-k clear-history

    ## A quiter setup
    ##set -g visual-activity off
    ##set -g visual-bell off
    ##set -g visual-silence off
    ##setw -g monitor-activity off
    ##set -g bell-action none

    ###########
    ## Status #
    ###########
    ## https://rudra.dev/posts/a-mininal-tmux-configuration-from-scratch/

    ## Set status bar on
    #set -g status on

    ## Update the status line every second
    #set -g status-interval 1

    ## Set the position of window lists.
    #set -g status-justify centre # [left | centre | right]

    ## Set Vi style keybinding in the status line
    #set -g status-keys vi

    ## Set the status bar position
    #set -g status-position top # [top, bottom]

    ## Set status bar background and foreground color.
    #set -g status-style fg=colour136,bg="#002b36"

    ## Set left side status bar length and style
    #set -g status-left-length 60
    #set -g status-left-style default

    ## Display the session name
    #set -g status-left "#[fg=green] ❐ #S #[default]"

    ## Display the os version (Mac Os)
    #set -ag status-left " #[fg=black] #[fg=green,bright]  #(sw_vers -productVersion) #[default]"

    ## Display the battery percentage (Mac OS)
    #set -ag status-left "#[fg=green,bg=default,bright] 🔋 #(pmset -g batt | tail -1 | awk '{print $3}' | tr -d ';') #[default]"

    ## Set right side status bar length and style
    #set -g status-right-length 140
    #set -g status-right-style default

    ## Display the cpu load (Mac OS)
    #set -g status-right "#[fg=green,bg=default,bright]  #(top -l 1 | grep -E "^CPU" | sed 's/.*://') #[default]"

    ## Display the date
    #set -ag status-right "#[fg=white,bg=default]  %a %d #[default]"

    ## Display the time
    #set -ag status-right "#[fg=colour172,bright,bg=default] ⌚︎%l:%M %p #[default]"

    ## Display the hostname
    #set -ag status-right "#[fg=cyan,bg=default] ☠ #H #[default]"

    ## Set the inactive window color and style
    #set -g window-status-style fg=colour244,bg=default
    #set -g window-status-format ' #I #W '

    ## Set the active window color and style
    #set -g window-status-current-style fg=black,bg=colour136
    #set -g window-status-current-format ' #I #W '

    ## Colors for pane borders(default)
    #setw -g pane-border-style fg=green,bg=black
    #setw -g pane-active-border-style fg=white,bg=black

    ## Active pane normal, other shaded out
    #setw -g window-style fg=colour240,bg=colour235
    #setw -g window-active-style fg=white,bg=black
  '';
}
