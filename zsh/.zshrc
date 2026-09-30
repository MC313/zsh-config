#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

### ---- PATH edits -----------------------------------------------
# Load login env in non-login interactive shells
[[ -o login ]] || { [ -r "$ZDOTDIR/.zprofile" ] && source "$ZDOTDIR/.zprofile"; }

### ---- alias values ---------------------------------------------
[ -r "$ZDOTDIR/.zsh_aliases" ] && source "$ZDOTDIR/.zsh_aliases"

# NODE_OPTIONS ipv4first is set in ~/.zshenv so non-interactive zsh (and Pi) inherit it.
# Re-apply here in case this file is sourced without zshenv having run first.
case ":${NODE_OPTIONS:-}:" in
  *"--dns-result-order=ipv4first"*) ;;
  *) export NODE_OPTIONS="${NODE_OPTIONS:+$NODE_OPTIONS }--dns-result-order=ipv4first" ;;
esac

### ---- plugin config  -------------------------------------------
# Initialise zsh completions once before loading plugins. zsh-nvm's Bash
# completion bridge checks for compinit and otherwise performs a second,
# expensive initialization of the same completion system.
fpath=("$ZDOTDIR/plugins/zsh-completions/src" $fpath)
fpath=("$HOME/.config/hcloud/completion/zsh" $fpath)
fpath=("$HOME/.config/tailscale/completion/zsh" $fpath)
autoload -Uz compinit
compinit
_comp_options+=(globdots)
autoload -U +X bashcompinit && bashcompinit

# Use the lazy-loading plugin when installed. Until submodules are initialized,
# retain the local nvm installation behavior from the Ubuntu config.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -r "$ZDOTDIR/plugins/zsh-nvm/zsh-nvm.plugin.zsh" ]]; then
  # These modes must be configured before sourcing the plugin.
  export NVM_LAZY_LOAD=true
  export NVM_AUTO_USE=true
  source "$ZDOTDIR/plugins/zsh-nvm/zsh-nvm.plugin.zsh"

  # Only auto-use when a .nvmrc exists to avoid slow chpwd on every cd.
  if [[ "$NVM_LAZY_LOAD" == true ]] && [[ "$NVM_AUTO_USE" == true ]] && (( $+functions[_zsh_nvm_auto_use] )); then
    autoload -Uz add-zsh-hook
    typeset -g NVM_AUTO_USE_LAST_NVMRC=""
    typeset -g NVM_AUTO_USE_LAST_VERSION=""

    _nvmrc_path() {
      local dir="$PWD"
      while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.nvmrc" ]]; then
          print -r -- "$dir/.nvmrc"
          return 0
        fi
        dir="${dir:h}"
      done
      return 1
    }

    _zsh_nvm_auto_use_wrapper() {
      local nvmrc_path
      nvmrc_path="$(_nvmrc_path)" || return 0
      local nvmrc_version
      nvmrc_version="$(< "$nvmrc_path")"
      [[ -z "$nvmrc_version" ]] && return 0

      if [[ "$NVM_AUTO_USE_LAST_NVMRC" == "$nvmrc_path" ]] && [[ "$NVM_AUTO_USE_LAST_VERSION" == "$nvmrc_version" ]]; then
        return 0
      fi

      if ! type nvm_find_nvmrc > /dev/null 2>&1; then
        [[ -f "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use
      fi
      _zsh_nvm_auto_use
      NVM_AUTO_USE_LAST_NVMRC="$nvmrc_path"
      NVM_AUTO_USE_LAST_VERSION="$nvmrc_version"
    }

    add-zsh-hook -d chpwd _zsh_nvm_auto_use
    add-zsh-hook chpwd _zsh_nvm_auto_use_wrapper
    _zsh_nvm_auto_use_wrapper
  fi
elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
fi

# Load other plugins
source "$ZDOTDIR/plugins/fast-syntax-highlighting/F-Sy-H.plugin.zsh"
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
# pnpm-auto-use plugin (Linux only)
if [[ "$OSTYPE" == "linux"* ]] && [ -f "$ZDOTDIR/plugins/pnpm-auto-use.plugin.zsh" ]; then
  source "$ZDOTDIR/plugins/pnpm-auto-use.plugin.zsh"
fi

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
# STARSHIP_CONFIG is selected in .zshenv, preserving explicit overrides.
# Skip under TERM=dumb (e.g. `zsh -i -c` from editor tasks/CI) — starship
# errors instead of silently no-op-ing when it can't render a prompt.
[[ "$TERM" != "dumb" ]] && eval "$(starship init zsh)"

# Python version management
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init - zsh)"
fi
