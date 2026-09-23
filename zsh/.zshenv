### 1. Zsh Array Optimization
# -U ensures entries are Unique (no duplicates)
# -T ties the lowercase array 'path' to the uppercase string 'PATH'
typeset -U path cdpath fpath manpath
typeset -gT PATH path

### 2. Shell Environment
export ZDOTDIR="$HOME/.zsh"
export AWS_PROFILE="default"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# Prefer IPv4 so Node does not hang on unreachable IPv6
case ":${NODE_OPTIONS:-}:" in
  *"--dns-result-order=ipv4first"*) ;;
  *) export NODE_OPTIONS="${NODE_OPTIONS:+$NODE_OPTIONS }--dns-result-order=ipv4first" ;;
esac

### 3. Directory Navigation
# This allows you to 'cd' into folders in ~/Dev or the current dir by name
cdpath=(~/Dev .)

### 4. Path Management
# We use the lowercase 'path' array for better readability.
# The order here is: First listed = Highest priority.
# pnpm shims live in $PNPM_HOME/bin, not $PNPM_HOME itself.
export PNPM_HOME="$HOME/.local/share/pnpm"
path=(
    "$HOME/.opencode/bin"
    "$HOME/.local/bin"
    "/usr/local/go/bin"
    "$PNPM_HOME/bin"
    $path
)

# Optional: If you use GOLANG, it's good practice to set GOPATH
# export GOPATH="$HOME/go"
# path=("$GOPATH/bin" $path)
