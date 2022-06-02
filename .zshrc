# brew?
eval "$(/opt/homebrew/bin/brew shellenv)"

export ZSH="/Users/hacksore/.oh-my-zsh"
ZSH_THEME="murilasso"

plugins=(git)
source $ZSH/oh-my-zsh.sh

export PATH="/usr/local/sbin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# the fuck is pretty cool
eval $(thefuck --alias)

# profile
source $HOME/.zprofile

# source personal stuff
source $HOME/personal/init.sh

