#!/bin/zsh
#
# .zprofile - Zsh file loaded on login.
#

# ~/.zsh/.zprofile

# Python version management
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Homebrew (Apple Silicon first, then generic)
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
  fi

  if [[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/opt/openssl/bin" ]]; then
    path=("$HOMEBREW_PREFIX/opt/openssl/bin" $path)
  fi

  # Added by OrbStack: command-line tools and integration
  # This won't be added again if you remove it.
  source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
fi
