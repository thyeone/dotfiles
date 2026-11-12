#!/bin/zsh
# nvm init lives in zsh/.zshrc; this script only installs Node.js LTS.

echo "📦 Setting up Node.js with nvm..."

if ! command -v brew >/dev/null 2>&1; then
  echo "⚠️  Homebrew not found. Please install Homebrew first."
  exit 1
fi

export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
nvm_sh="$(brew --prefix nvm 2>/dev/null)/nvm.sh"
if [[ ! -s "$nvm_sh" ]]; then
  echo "⚠️  nvm not found. Please install nvm first via Homebrew."
  exit 1
fi
source "$nvm_sh"

echo "📦 Installing Node.js LTS version..."
nvm install --lts || exit 1
nvm alias default 'lts/*'

echo "✅ Node.js LTS setup completed!"
echo "   Current version: $(node --version)"
echo "   npm version: $(npm --version)"
