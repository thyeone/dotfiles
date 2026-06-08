#!/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
AUTO_MODE=${1:-false}

echo "📦 Setting up Homebrew..."

# Install Homebrew if not already installed
if ! command -v brew >/dev/null 2>&1; then
  echo "📦 Installing Homebrew..."
  if [ "$AUTO_MODE" = true ] || [ -n "$NONINTERACTIVE" ]; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Add Homebrew to PATH for Apple Silicon
  if [[ $(uname -m) == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "✅ Homebrew already installed"
fi

# Install packages from Brewfile
if [ -f "$DOTFILES_DIR/brew/Brewfile" ]; then
  echo "📦 Syncing packages from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/brew/Brewfile"
else
  echo "⚠️ Brewfile not found at $DOTFILES_DIR/brew/Brewfile"
fi

echo "✅ Homebrew setup completed!"
