autoload -Uz add-zsh-hook

load-pnpmrc() {
  if (( ! $+commands[pnpm] )); then
    return
  fi

  local nvmrc_file=".nvmrc"
  if [[ ! -f "$nvmrc_file" ]]; then
    return
  fi

  local local_node_version=$(cat "$nvmrc_file")
  if [[ -z "$local_node_version" ]]; then
    return
  fi

  local current_node_version=$(node --version 2>/dev/null)
  current_node_version=${current_node_version/v/}

  if [[ "$current_node_version" == "$local_node_version" ]]; then
    return
  fi

  pnpm env use --global "$local_node_version" > /dev/null 2>&1
}

auto-load-pnpmrc() {
  local current_dir=$(pwd -P)

  if [[ "$current_dir" != "$PREV_PWD" ]]; then
    PREV_PWD="$current_dir"
    load-pnpmrc
  fi
}

add-zsh-hook chpwd auto-load-pnpmrc
