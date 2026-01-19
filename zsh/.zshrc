#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

source ~/.zsh/.zsh_aliases

### ---- environment variables ------------------------------------
# These variables are only available in interactive shells
source ~/.zshenv

### ---- plugin config  -------------------------------------------
source ~/.zsh/plugins/fast-syntax-highlighting/F-Sy-H.plugin.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/pnpm-auto-use.plugin.zsh
fpath=(~/.zsh/plugins/zsh-completions/src $fpath)
autoload -Uz compinit; compinit; _comp_options+=(globdots)
autoload -U +X bashcompinit && bashcompinit

### ---- history config ------------------------------------------
export HISTFILE=~/.zsh/.zsh_history
# How many commands zsh will load to memory.
export HISTSIZE=10000
# How many commands history will save on file.
export SAVEHIST=10000
# Add timestamps to history entries.
setopt EXTENDED_HISTORY
# Ignores lines that begin with spaces.
setopt HIST_IGNORE_SPACE
# Removes any excess blanks that mean nothing to the shell.
setopt HIST_REDUCE_BLANKS
# delete duplicates first when HISTFILE size exceeds HISTSIZE.
setopt HIST_EXPIRE_DUPS_FIRST
# Only prevents duplicates from being written to the history file
setopt HIST_SAVE_NO_DUPS
# Removes duplicates from the in-memory history as well as from what gets saved to the history file, 
# keeping only the most recent occurrence of each command
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
eval "$(starship init zsh)"

# Cursor AI IDE launcher function
# function cursor() {
#     local args=""
#     if [ $# -eq 0 ]; then
#         args=$(pwd)
#     else
#         for arg in "$@"; do
#             args="$args $arg"
#         done
#     fi
#     (nohup $HOME/Applications/cursor/squashfs-root/AppRun --no-sandbox "$args" >/dev/null 2>&1 &)
# }
# export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/home/malcolm/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# opencode
export PATH=/home/malcolm/.opencode/bin:$PATH
