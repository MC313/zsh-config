#!/usr/bin/env bash

set -u
set -o pipefail

# No arguments. NVM_DIR overrides the default installation in $HOME/.nvm.
# Avoid errexit: nvm uses expected non-zero statuses for version lookups.
readonly NODE_SETUP_NVM_VERSION='v0.40.4'

report_error() {
    printf 'Error: %s\n' "$1" >&2
}

install_nvm() {
    local parent_dir

    [[ -s "${NVM_DIR}/nvm.sh" ]] && return 0

    printf '%s\n' 'Installing nvm...'
    parent_dir=$(dirname "${NVM_DIR}") || return 1
    mkdir -p "${parent_dir}" || return 1
    git clone --depth 1 --branch "${NODE_SETUP_NVM_VERSION}" \
        'https://github.com/nvm-sh/nvm.git' "${NVM_DIR}" || return 1
}

has_node_installation() (
    local node_bin
    local -a node_bins

    # Non-matching patterns become empty arrays instead of literal paths.
    shopt -s nullglob
    node_bins=("${NVM_DIR}"/versions/node/*/bin/node "${NVM_DIR}"/v*/bin/node)
    for node_bin in "${node_bins[@]}"; do
        [[ -x "${node_bin}" ]] && return 0
    done
    return 1
)

configure_node() (
    local default_version
    local installed_version

    # nvm is not compatible with nounset/pipefail. Limit that exception to
    # this subshell and handle failures explicitly rather than using errexit.
    set +u
    set +o pipefail

    # Dotbot runs outside the interactive Zsh plugin setup.
    # shellcheck disable=SC1091
    source "${NVM_DIR}/nvm.sh" --no-use || return 1

    if has_node_installation; then
        printf '%s\n' 'An nvm-managed Node.js version is already installed.'
    else
        printf '%s\n' 'Installing Node.js LTS...'
        nvm install --lts || return 1
    fi

    # A missing/dangling alias reports N/A with a non-zero exit status.
    # Preserve a working default; repair only that expected lookup failure.
    if default_version=$(nvm version default); then
        :
    elif [[ "${default_version}" == 'N/A' ]]; then
        installed_version=$(nvm version node) || return 1
        nvm alias default "${installed_version}" || return 1
    else
        report_error 'Could not resolve the default Node.js version.'
        return 1
    fi

    nvm use default || return 1
    node --version || return 1
    npm --version || return 1
)

main() {
    if (( $# > 0 )); then
        report_error 'This script takes no arguments; set NVM_DIR to override the installation directory.'
        return 1
    fi

    if [[ -z "${NVM_DIR:-}" ]]; then
        : "${HOME:?HOME is required when NVM_DIR is unset}"
        export NVM_DIR="${HOME}/.nvm"
    else
        export NVM_DIR
    fi

    if [[ "${NVM_DIR}" != /* || "${NVM_DIR}" == '/' ]]; then
        report_error 'NVM_DIR must be an absolute installation directory, not the filesystem root.'
        return 1
    fi

    install_nvm || {
        report_error 'Could not install nvm.'
        return 1
    }
    configure_node || {
        report_error 'Could not configure Node.js.'
        return 1
    }
}

main "$@"
