export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="murilasso"

plugins=(git)
source $ZSH/oh-my-zsh.sh

export PATH="/usr/local/sbin:$PATH"
export NVM_DIR="$HOME/.nvm"

# we want things per user
export HOMEBREW_PREFIX="$HOME/homebrew"
export HOMEBREW_CELLAR="$HOME/homebrew/Cellar"
export HOMEBREW_CASK_OPTS="--appdir=~/Applications --fontdir=~/Library/Fonts"

# eval brew
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

# auto complete for brew
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

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

# java
export PATH="/Users/blazing/homebrew/opt/openjdk/bin:$PATH"