#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

source ~/.zsh/.zsh_aliases

### ---- environment variables ------------------------------------
# These variables are only available in interactive shells
export AWS_PROFILE=default

### ---- plugin config  -------------------------------------------
source ~/.zsh/plugins/fast-syntax-highlighting/F-Sy-H.plugin.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath=(~/.zsh/plugins/zsh-completions/src $fpath)
autoload -Uz compinit; compinit; _comp_options+=(globdots)

### ---- history config ------------------------------------------
export HISTFILE=~/.zsh/.zsh_history
# How many commands zsh will load to memory.
export HISTSIZE=10000
# How many commands history will save on file.
export SAVEHIST=10000
# Ignores lines that begin with spaces.
setopt HIST_IGNORE_SPACE
# Removes any excvess blanks that mean nothing to the shell.
setopt HIST_REDUCE_BLANKS
# delete duplicates first when HISTFILE size exceeds HISTSIZE.
setopt HIST_EXPIRE_DUPS_FIRST
# History won't save duplicates.
setopt HIST_IGNORE_ALL_DUPS
# History won't show duplicates on search.
setopt HIST_FIND_NO_DUPS
# Appends after every command.
setopt INC_APPEND_HISTORY
# Share history across all your terminal windows.
setopt SHARE_HISTORY

### ---- other config options -------------------------------------
# Allows you to change directories without using the 'cd' command.
setopt AUTO_CD

### ---- prompt config --------------------------------------------
# PROMPT config is handled by Starship shell

### ---- Functions ------------------------------------------------
# Function to display a basic progress meter
show_progress() {
    echo -n "["
    for i in $(seq 1 50); do
        if [ "$1" -ge "$i" ]; then
            echo -n "#"
        else
            echo -n " "
        fi
    done
    echo -n "]"
    echo
}

### ---- Starship cross-shell prompt ------------------------------
# Check and install Starship
echo "Checking for Starship..."
if ! command -v starship &> /dev/null; then
    echo "Starship not found. Installing..."
    show_progress 25
    curl -fsSL https://starship.rs/install.sh | sh
    show_progress 50
else
    show_progress 50
    echo "Starship is already installed."
fi

eval "$(starship init zsh)"
