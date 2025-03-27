cdpath=(~/Dev .)
export AWS_PROFILE=default
export STARSHIP_CONFIG=~/.config/starship.toml
export ZDOTDIR=$HOME/.zsh
# pnpm
export PNPM_HOME="/home/malcolm/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
