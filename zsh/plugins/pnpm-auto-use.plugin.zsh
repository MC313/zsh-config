autoload -Uz add-zsh-hook

typeset -g PNPM_AUTO_USE_LAST_NVMRC=""
typeset -g PNPM_AUTO_USE_LAST_VERSION=""

load-pnpmrc() {
  if (( ! $+commands[pnpm] )); then
    return
  fi

  # Only opt-in when the repo explicitly asks pnpm to manage Node versions.
  if [[ ! -f ".npmrc" ]] || ! command grep -q "use-node-version" ".npmrc"; then
    return
  fi

  local nvmrc_file=".nvmrc"
  local nvmrc_path="$PWD/$nvmrc_file"
  if [[ ! -f "$nvmrc_file" ]]; then
    return
  fi

  local local_node_version=$(cat "$nvmrc_file")
  if [[ -z "$local_node_version" ]]; then
    return
  fi

  if [[ "$PNPM_AUTO_USE_LAST_NVMRC" == "$nvmrc_path" ]] && [[ "$PNPM_AUTO_USE_LAST_VERSION" == "$local_node_version" ]]; then
    return
  fi

  local current_node_version=$(node --version 2>/dev/null)
  current_node_version=${current_node_version/v/}

  if [[ "$current_node_version" == "$local_node_version" ]]; then
    PNPM_AUTO_USE_LAST_NVMRC="$nvmrc_path"
    PNPM_AUTO_USE_LAST_VERSION="$local_node_version"
    return
  fi

  if pnpm env use --global "$local_node_version" > /dev/null 2>&1; then
    PNPM_AUTO_USE_LAST_NVMRC="$nvmrc_path"
    PNPM_AUTO_USE_LAST_VERSION="$local_node_version"
  fi
}

auto-load-pnpmrc() {
  local current_dir=$(pwd -P)

  if [[ "$current_dir" != "$PREV_PWD" ]]; then
    PREV_PWD="$current_dir"
    load-pnpmrc
  fi
}

add-zsh-hook chpwd auto-load-pnpmrc
