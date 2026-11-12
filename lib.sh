# Shared helpers for setup scripts. Source this file; do not execute it.

DOTFILES_DIR="${0:A:h}"

# link <source> <target>: symlink target -> source, backing up an existing real file/dir.
link() {
  local src="$1" dst="$2"
  if [[ ! -e "$src" ]]; then
    echo "⚠️  Source not found: $src"
    return 1
  fi
  mkdir -p "${dst:h}"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "✅ Already linked: $dst"
    return 0
  fi
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    local backup="$dst.backup.$(date +%Y%m%d%H%M%S)"
    echo "⚠️  Backing up existing file: $dst -> $backup"
    mv "$dst" "$backup"
  fi
  echo "🔗 Linking: $dst -> $src"
  ln -sfn "$src" "$dst"
}

# install_extensions <cli> <list-file>
install_extensions() {
  local cli="$1" list="$2"
  if ! command -v "$cli" >/dev/null 2>&1; then
    echo "⚠️  $cli not found in PATH. Skipping extension installation."
    return 0
  fi
  echo "📦 Installing extensions with $cli..."
  grep -v '^[[:space:]]*$' "$list" | xargs -n 1 "$cli" --install-extension
}
