# Set up zsh
export ZSH="$HOME/.oh-my-zsh"

# good zsh theme
ZSH_THEME="murilasso"

# Load any cool plugins
# https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins#plugins
plugins=(
  nvm
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-vi-mode
)

# allowing for use of .config dir
export XDG_CONFIG_HOME="$HOME/.config"

# load brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# load ohmyzsh
source $ZSH/oh-my-zsh.sh

# good fuzzy
source $HOME/.fzf.zsh

# profile
source $HOME/.zprofile

# no auto update brew
export HOMEBREW_NO_AUTO_UPDATE="1"

# add cargo to path
export PATH="$HOME/.cargo/bin:$PATH"

# add 1p ssh agent
export SSH_AUTH_SOCK="$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# add ruby to path
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# java
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/homebrew/opt/openjdk@17/bin:$PATH"

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
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# make new astro theme work
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5e5e5e"

# op cli plugins
source "$HOME/.config/op/plugins.sh"

# add bins to path
export PATH="$HOME/bin:$PATH"

# clear the suggestion with ctrl + space
bindkey '^ ' autosuggest-clear

# the fuck
eval $(thefuck --alias)
