# Set up zsh
export ZSH="$HOME/.oh-my-zsh"

# good zsh theme
ZSH_THEME="murilasso"

# Load any cool plugins
plugins=(
  git
  nvm
  sudo
  web-search
  dirhistory
  history
)

# load zsh
source $ZSH/oh-my-zsh.sh

# good fuzzy
source $HOME/.fzf.zsh

# profile
source $HOME/.zprofile

# auto complete for brew
if type brew &>/dev/null
then
  FPATH=${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}

  autoload -Uz compinit
  compinit
fi

# we want things per user (this seems to be rather sketchy according to Mike)
# but it makes things annoying to have multiple users and brew install on the same machine
if [[ $(uname) == "Darwin" ]]; then
  export HOMEBREW_PREFIX="$HOME/homebrew"
  export HOMEBREW_CELLAR="$HOME/homebrew/Cellar"
  export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications --fontdir=$HOME/Library/Fonts"
else
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

# load nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm

# eval brew
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

# highlighting
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# suggestions 
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# load the fuck
eval $(thefuck --alias)

# load exported vars last
# skip auto update for ohmyzsh
export DISABLE_AUTO_UPDATE=true

export PATH="/usr/local/sbin:$PATH"
export NVM_DIR="$HOME/.nvm"

# no auto update brew
export HOMEBREW_NO_AUTO_UPDATE="1"

# add cargo to path
export PATH="$HOME/.cargo/bin/:$PATH"

# add 1p ssh agent
export SSH_AUTH_SOCK="$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# java
export JAVA_HOME="$HOME/homebrew/Cellar/openjdk/11/libexec/openjdk.jdk/Contents/Home"
export PATH="$HOME/homebrew/opt/openjdk@11/bin:$PATH"

# hist settings
export HISTSIZE=1000000
export SAVEHIST=1000000

# some good settings for hist
export HIST_IGNORE_ALL_DUPS="1"
export HIST_SAVE_NO_DUPS="1"
export HIST_REDUCE_BLANKS="1"
export INC_APPEND_HISTORY_TIME="1"
export EXTENDED_HISTORY="1"

# load fzf for fuzzy
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="/Users/hacksore/homebrew/opt/make/libexec/gnubin:$PATH"
