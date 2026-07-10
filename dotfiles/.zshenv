# Minimal PATH bootstrap for non-interactive zsh shells launched by GUI apps.
# Keep this file side-effect free: no prompts, evals, starship, or slow commands.

typeset -gaU path

for _codex_path_dir in \
  "$HOME/.bun/bin" \
  "$HOME/.npm-global/bin" \
  "$HOME/.opencode/bin" \
  "$HOME/Library/pnpm" \
  "/opt/homebrew/sbin" \
  "/opt/homebrew/bin" \
  "$HOME/.cargo/bin" \
  "$HOME/.local/bin"
do
  [[ -d "$_codex_path_dir" ]] && path=("$_codex_path_dir" $path)
done

unset _codex_path_dir
export PATH

# 1Password service-account token for agent shells: any agent (Claude/Codex/etc.)
# launched on this machine can read the Agents vault via `op` with no authorize
# modal. Token stays in the macOS Keychain; loaded only if not already inherited.
if [[ -z "${OP_SERVICE_ACCOUNT_TOKEN:-}" ]] && command -v security >/dev/null 2>&1; then
  export OP_SERVICE_ACCOUNT_TOKEN="$(security find-generic-password -a "$USER" -s op-agent -w 2>/dev/null)"
fi

# Avoid 1Password desktop-app probing in non-interactive agent shells. Tahoe's
# app-data protection can otherwise block `op`; the service-account path does
# not need desktop integration or the daemon cache.
export OP_LOAD_DESKTOP_APP_SETTINGS=false
export OP_CACHE=false
