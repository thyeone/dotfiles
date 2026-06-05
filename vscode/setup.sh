#!/bin/zsh

# vscode 익스텐션 txt로 추출하는법

# .vscode/extensions 디렉토리로 가서

# ```
# code --list-extensions > vscode-extensions.txt
# ```

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
VSCODE_DIR="$DOTFILES_DIR/vscode"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

echo "📦 Setting up VSCode configuration..."

# Create VSCode User directory if it doesn't exist
mkdir -p "$VSCODE_USER_DIR"

# Function to create symlink, backing up existing file if needed
create_symlink() {
  local source_file="$1"
  local target_file="$2"
  local file_name=$(basename "$source_file")

  if [ -L "$target_file" ]; then
    echo "⚠️  Removing existing symlink: $target_file"
    rm "$target_file"
  elif [ -f "$target_file" ]; then
    echo "⚠️  Backing up existing file: $target_file -> ${target_file}.backup"
    mv "$target_file" "${target_file}.backup"
  fi

  echo "🔗 Creating symlink: $target_file -> $source_file"
  ln -s "$source_file" "$target_file"
}

# Setup settings.json
if [ -f "$VSCODE_DIR/settings.json" ]; then
  create_symlink "$VSCODE_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"
else
  echo "⚠️  settings.json not found at $VSCODE_DIR/settings.json"
fi

# Install VSCode extensions from vscode-extensions.txt
if [ -f "$VSCODE_DIR/vscode-extensions.txt" ]; then
  if command -v code &> /dev/null; then
    echo "📦 Installing VSCode extensions..."
    xargs -n 1 code --install-extension < "$VSCODE_DIR/vscode-extensions.txt"
    echo "✅ VSCode extensions installation completed"
  else
    echo "⚠️  VSCode (code) not found in PATH. Skipping extension installation."
  fi
else
  echo "⚠️  vscode-extensions.txt not found at $VSCODE_DIR/vscode-extensions.txt"
fi

echo "✅ VSCode configuration setup completed!"
