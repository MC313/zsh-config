#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

source ~/.zsh/.zsh_aliases

### ---- environment variables ------------------------------------
# These variables are only available in interactive shells
source ~/.zshenv

# NODE_OPTIONS ipv4first is set in ~/.zshenv so non-interactive zsh (and Pi) inherit it.
# Re-apply here in case this file is sourced without zshenv having run first.
case ":${NODE_OPTIONS:-}:" in
  *"--dns-result-order=ipv4first"*) ;;
  *) export NODE_OPTIONS="${NODE_OPTIONS:+$NODE_OPTIONS }--dns-result-order=ipv4first" ;;
esac

### ---- plugin config  -------------------------------------------
source ~/.zsh/plugins/fast-syntax-highlighting/F-Sy-H.plugin.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/pnpm-auto-use.plugin.zsh
fpath=(~/.zsh/plugins/zsh-completions/src $fpath)
fpath=(~/.config/hcloud/completion/zsh $fpath)
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

# pnpm
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# nvm end

# python
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init - zsh)"
fi
# python end
