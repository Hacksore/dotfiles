export ZSH="/Users/hacksore/.oh-my-zsh"
ZSH_THEME="murilasso"

plugins=(git)
source $ZSH/oh-my-zsh.sh

export PATH="/usr/local/sbin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

alias config="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

eval $(thefuck --alias)
