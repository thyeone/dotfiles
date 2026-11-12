# Homebrew prefix (set by `brew shellenv` in ~/.zprofile); avoid repeated `brew --prefix` calls
BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=(
  git
)

source "$ZSH/oh-my-zsh.sh"

# nvm (after oh-my-zsh so compinit runs once)
export NVM_DIR="$HOME/.nvm"
[ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$BREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# must be sourced last among plugins
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Android, iOS
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# alias
alias gl="git log --oneline --graph --all --decorate"
alias ccc="claude --dangerously-skip-permissions"
alias ll="ls -al"
alias cpyolo="copilot --allow-all-tools"
alias myip="ipconfig getifaddr en0"

#openssl
export LDFLAGS="-L$BREW_PREFIX/opt/openssl@3/lib"
export CPPFLAGS="-I$BREW_PREFIX/opt/openssl@3/include"
export PATH="$BREW_PREFIX/opt/openssl@3/bin:$PATH"

# uv tool installs (graphify 등)
export PATH="$HOME/.local/bin:$PATH"

# added by dbx installer
export PATH="$HOME/.dbx/bin:$PATH"

# dedupe PATH entries
typeset -U path
