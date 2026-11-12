#!/bin/zsh
source "${0:A:h:h}/lib.sh"
AUTO_MODE=${1:-false}

echo "📦 Setting up Homebrew..."

if ! command -v brew >/dev/null 2>&1; then
  echo "📦 Installing Homebrew..."
  [[ "$AUTO_MODE" == true ]] && export NONINTERACTIVE=1
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1

  if [[ $(uname -m) == arm64 ]]; then
    grep -qs 'brew shellenv' ~/.zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "✅ Homebrew already installed"
fi

echo "📦 Syncing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/brew/Brewfile" || exit 1

echo "✅ Homebrew setup completed!"
