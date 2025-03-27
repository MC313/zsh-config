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
source ~/.zsh/plugins/zsh-auto-pnpm-use/zsh-auto-pnpm-use.plugin.zsh
fpath=(~/.zsh/plugins/zsh-completions/src $fpath)
autoload -Uz compinit; compinit; _comp_options+=(globdots)

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
