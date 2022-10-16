export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="murilasso"

plugins=(
  git
  sudo
  web-search
  dirhistory
  history
  # you need to do this for it to work
  # git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

export PATH="/usr/local/sbin:$PATH"
export NVM_DIR="$HOME/.nvm"

# we want things per user
export HOMEBREW_PREFIX="$HOME/homebrew"
export HOMEBREW_CELLAR="$HOME/homebrew/Cellar"
export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications --fontdir=$HOME/Library/Fonts"

# eval brew
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

# no auto update brew
export HOMEBREW_NO_AUTO_UPDATE="0"

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
source $HOME/.fzf.zsh

# profile
source $HOME/.zprofile

# add 1p ssh
export SSH_AUTH_SOCK="$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# java
export PATH="$HOME/homebrew/opt/openjdk/bin:$PATH"
export JAVA_HOME="$HOME/homebrew/Cellar/openjdk/19/libexec/openjdk.jdk/Contents/Home"

# highling
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# competions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

# hist settings
export HISTSIZE=1000000
export SAVEHIST=1000000

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY_TIME
setopt EXTENDED_HISTORY