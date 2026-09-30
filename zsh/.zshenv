### 1. Zsh Array Optimization
# -U ensures entries are Unique (no duplicates)
# -T ties the lowercase array 'path' to the uppercase string 'PATH'
typeset -U path cdpath fpath manpath
typeset -gT PATH path

### 2. Shell Environment
export ZDOTDIR="$HOME/.zsh"
export AWS_PROFILE="default"
export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$ZDOTDIR/.config/starship.toml}"

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
# pnpm uses the platform's conventional data directory. PNPM_BIN_DIR is the
# platform-specific location for global executables and is added to PATH.
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
    export PNPM_BIN_DIR="$PNPM_HOME"
else
    export PNPM_HOME="$HOME/.local/share/pnpm"
    # Preserve the existing Ubuntu layout, where pnpm's global executables
    # live in the bin/ subdirectory.
    export PNPM_BIN_DIR="$PNPM_HOME/bin"
fi
path=(
    "$HOME/.opencode/bin"
    "$HOME/.local/bin"
    "/usr/local/go/bin"
    "$HOME/go/bin"
    "$PNPM_BIN_DIR"
    $path
)
