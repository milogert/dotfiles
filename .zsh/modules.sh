# Checker for success.
suc=0

##############################################################################
# Setup zsh-syntax-highlighting.
# Check for directory.
if [[ ! -d $MODULES/zsh-syntax-highlighting ]]; then
  # Doesn't exist: Clone the repository.
  git clone https://github.com/zsh-users/zsh-syntax-highlighting $MODULES/zsh-syntax-highlighting

  suc=1
else
  suc=2
fi

# If the clone succeeded, setup.
if [[ ($? -eq 0 && $suc -eq 1) || $suc -eq 2 ]]; then
  # Source the file.
  source $MODULES/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

suc=0

##############################################################################
# Setup zsh-history-substring-search.

# Check for directory.
if [[ ! -d $MODULES/zsh-history-substring-search ]]; then
  # Doesn't exist: Clone the repository.
  git clone https://github.com/zsh-users/zsh-history-substring-search $MODULES/zsh-history-substring-search 

  suc=1
else
  suc=2
fi

# If the clone succeeded, setup.
if [[ ($? -eq 0 && $suc -eq 1) || $suc -eq 2 ]]; then
  # Source the file.
  source $MODULES/zsh-history-substring-search/zsh-history-substring-search.zsh

  # bind UP and DOWN arrow keys
  zmodload zsh/terminfo
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down

  # bind P and N for EMACS mode
  bindkey -M emacs '^P' history-substring-search-up
  bindkey -M emacs '^N' history-substring-search-down

  # bind k and j for VI mode
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
fi

suc=0

##############################################################################
# Setup zsh-autosuggestions

# Check for directory.
#if [[ ! -d $MODULES/zsh-autosuggestions ]]; then
#  # Doesn't exist: Clone the repository.
#  git clone https://github.com/tarruda/zsh-autosuggestions ~/.zsh/modules/zsh-autosuggestions
#  suc=1
#else
#  suc=2
#fi

# If git clone succeeded, setup.
#if [[ ($? -eq 0 && $suc -eq 1) || $suc -eq 2 ]]; then
#  # Source the file.
#  source ~/.zsh/modules/zsh-autosuggestions/autosuggestions.zsh
#
#  # Enable autosuggestions automatically
#  zle-line-init() {
#    zle autosuggest-start
#  }
#
#  zle -N zle-line-init
#
#  # use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
#  # zsh-autosuggestions is designed to be unobtrusive)
#  bindkey '^T' autosuggest-toggle
#fi

suc=0


