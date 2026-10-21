#!/usr/bin/env bash
#
# Install the global git hooks from this repo and point core.hooksPath at them.
#
# The hooks are a single shim (git-hooks/_shim) symlinked under every git hook
# name. It (1) enforces "main is PR-only" on pre-push — redirecting a direct
# push to main onto an auto/<slug>-<sha> branch — and (2) chains to each repo's
# own hook, so per-repo hooks (lefthook, husky, ...) keep working even though
# core.hooksPath replaces the per-repo hooks directory.
#
# Idempotent: safe to re-run. Bypass a guarded push with `git push --no-verify`.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
shim_src="${repo_root}/git-hooks/_shim"
hooks_dir="${XDG_CONFIG_HOME:-$HOME/.config}/git/hooks"

if [ ! -f "$shim_src" ]; then
  echo "error: ${shim_src} not found" >&2
  exit 1
fi
chmod +x "$shim_src"

mkdir -p "$hooks_dir"

# Git's standard client-side hooks; each name symlinks to the shim, which reads
# its own name to decide behaviour.
hooks="
applypatch-msg pre-applypatch post-applypatch pre-commit pre-merge-commit
prepare-commit-msg commit-msg post-commit pre-rebase post-checkout post-merge
pre-push pre-auto-gc post-rewrite post-index-change sendemail-validate
fsmonitor-watchman
"
for h in $hooks; do
  ln -sf "$shim_src" "${hooks_dir}/${h}"
done

git config --global core.hooksPath "$hooks_dir"

echo "git hooks installed: ${hooks_dir}/<hook> -> ${shim_src}"
echo "core.hooksPath set to ${hooks_dir}"
echo "bypass a guarded push:  git push --no-verify"
