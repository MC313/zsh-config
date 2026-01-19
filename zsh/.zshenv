### 1. Zsh Array Optimization
# -U ensures entries are Unique (no duplicates)
# -T ties the lowercase array 'path' to the uppercase string 'PATH'
typeset -U path cdpath fpath manpath
typeset -gT PATH path

### 2. Shell Environment
export ZDOTDIR="$HOME/.zsh"
export AWS_PROFILE="default"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

### 3. Directory Navigation
# This allows you to 'cd' into folders in ~/Dev or the current dir by name
cdpath=(~/Dev .)

### 4. Path Management
# We use the lowercase 'path' array for better readability.
# The order here is: First listed = Highest priority.
path=(
    "$HOME/.opencode/bin"
    "$HOME/.local/bin"
    "/usr/local/go/bin"
    "/home/malcolm/.local/share/pnpm"
    $path
)

### 5. Tool Specifics
export PNPM_HOME="/home/malcolm/.local/share/pnpm"

# Optional: If you use GOLANG, it's good practice to set GOPATH
# export GOPATH="$HOME/go"
# path=("$GOPATH/bin" $path)