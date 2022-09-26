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

# add 1p ssh
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/hacksore/Downloads/google-cloud-sdk 2/path.zsh.inc' ]; then . '/Users/hacksore/Downloads/google-cloud-sdk 2/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/hacksore/Downloads/google-cloud-sdk 2/completion.zsh.inc' ]; then . '/Users/hacksore/Downloads/google-cloud-sdk 2/completion.zsh.inc'; fi
