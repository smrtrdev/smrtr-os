# Feature: Development Tools

## Summary

Install essential development tools and editors for a productive coding environment.

## Requirements

### Editor: Neovim
- `neovim` — Primary text editor
- Install a preconfigured Neovim distribution (user choice):
  - **LazyVim** (recommended) — Modern, fast, well-maintained
  - Or allow user to bring their own nvim config
- Set `EDITOR=nvim` and `VISUAL=nvim` (done in shell feature)

### Version Management: Mise
- `mise` (AUR: `mise-bin`) — Polyglot version manager (replaces asdf, nvm, pyenv, etc.)
- Configure in `~/.config/mise/config.toml` with commonly needed tools:
  ```toml
  [tools]
  node = "lts"
  python = "latest"
  ```
- Shell activation is handled in spec 02:
  - Bash: `eval "$(mise activate bash)"` in .bashrc
  - Nushell: `mise activate nu | save -f ~/.cache/mise/init.nu` sourced in config.nu

### Git
- `git` (already in base)
- `github-cli` (`gh`) — GitHub integration
- `lazygit` — Terminal UI for git
- Provide a sensible `~/.config/git/config`:
  ```ini
  [init]
  defaultBranch = main
  [pull]
  rebase = true
  [push]
  autoSetupRemote = true
  [core]
  editor = nvim
  ```
- Git user name/email are NOT configured (user sets these themselves)

### Podman (rootless containers)
- `podman`, `podman-compose` — Daemonless, rootless container engine (drop-in Docker replacement)
- `buildah` — OCI image builder
- No group membership or daemon needed — Podman runs rootless out of the box
- Enable user lingering for long-running containers: `sudo loginctl enable-linger $USER`
- Configure `registries.conf` to include `docker.io` as unqualified search registry:
  ```
  # ~/.config/containers/registries.conf
  unqualified-search-registries = ["docker.io"]
  ```
- Optional: alias `docker` to `podman` in shell configs for compatibility

### Additional CLI Tools
- `make`, `cmake` — Build tools
- `jq`, `yq` — JSON/YAML processing
- `httpie` or `curl` — HTTP client (curl already in base)
- `tokei` — Code statistics
- `hyperfine` — Benchmarking tool
- `difftastic` — Structural diff tool (AUR)

### Claude Code (optional)
- If `node` is available (via mise), offer to install `claude-code` globally:
  `npm install -g @anthropic-ai/claude-code`

## Acceptance Criteria

- `nvim` launches with a configured IDE-like experience.
- `mise` can install and switch between tool versions.
- `gh auth login` works for GitHub authentication.
- `lazygit` opens in any git repository.
- `podman run hello-world` works without sudo (rootless).

## Dependencies

- `01-base-packages` (base-devel, git)
- `02-shell` (bashrc integration for mise, editor vars)
