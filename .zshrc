export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="murilasso"

# alias to open this file
alias profile="code $HOME/.zshrc"

plugins=(git)
source $ZSH/oh-my-zsh.sh

export PATH="/usr/local/sbin:$PATH"
export NVM_DIR="$HOME/.nvm"

# we want things per user
export HOMEBREW_PREFIX="$HOME/homebrew"

# eval brew
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

# for nvm to work right
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# the fuck is pretty cool
eval $(thefuck --alias)

# add cargo to path
export PATH="$HOME/.cargo/bin/:$PATH"

# good fuzzy
source ~/.fzf.zsh

# profile
source $HOME/.zprofile

# add 1p ssh
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock