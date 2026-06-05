# nvm configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Android, iOS
export ANDROID_HOME=/Users/macbook/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tool

# alias
alias gl="git log --oneline --graph --all --decorate"          
alias ccc="claude --dangerously-skip-permissions"   
alias ll="ls -al"                                      
