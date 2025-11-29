# disable shell cheeck
# shellcheck disable=SC2034
# shellcheck disable=SC1091

# Set up zsh
export ZSH="$HOME/.oh-my-zsh"

# good zsh theme
ZSH_THEME="murilasso"

# some programs require this for ~/.config
export XDG_CONFIG_HOME="$HOME/.config"

# make path either linux or mac for brew
if [ -d "/opt/homebrew/bin" ]; then
  export HOMEBREW_PATH="/opt/homebrew"
else
  export HOMEBREW_PATH="/home/linuxbrew/.linuxbrew"
fi

# load brew
eval "$($HOMEBREW_PATH/bin/brew shellenv)"

# force utf8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# load ohmyzsh
source "$ZSH/oh-my-zsh.sh"

# good fuzzy
eval "$(fzf --zsh)"

# load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PATH/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PATH/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "$HOMEBREW_PATH/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PATH/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# profile
source "$HOME/.zprofile"

# load zsh plugins
source "$HOMEBREW_PATH/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PATH/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# no auto update brew
export HOMEBREW_NO_AUTO_UPDATE="1"

# add cargo to path
export PATH="$HOME/.cargo/bin:$PATH"

# add 1p goodies for mac only
if [ "$(uname)" = "Darwin" ]; then
  export SSH_AUTH_SOCK="$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"

  # op cli plugins
  source "$HOME/.config/op/plugins.sh"
fi

# add ruby to path
export PATH="$HOMEBREW_PATH/opt/ruby/bin:$PATH"

# java
export JAVA_HOME="$HOMEBREW_PATH/opt/openjdk@23/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/homebrew/opt/openjdk@23/bin:$PATH"

# hist settings
export HISTSIZE=1000000
export SAVEHIST=1000000

# some good settings for hist
export HIST_IGNORE_ALL_DUPS="1"
export HIST_SAVE_NO_DUPS="1"
export HIST_REDUCE_BLANKS="1"
export INC_APPEND_HISTORY_TIME="1"
export EXTENDED_HISTORY="1"

# make new astro theme work
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5e5e5e"

# add bins to path
export PATH="$HOME/bin:$PATH"

# clear the suggestion with ctrl + space
bindkey '^ ' autosuggest-clear

# accept the suggestion with ctrl + j
bindkey '^j' autosuggest-accept

# add aws autocomplet
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C "$HOMEBREW_PATH/bin/aws_completer" aws

# allow alias to be expanded
setopt completealiases

export LIBRARY_PATH="$LIBRARY_PATH:$HOMEBREW_PATH/lib"

# path adds
export PATH="$PATH:$HOME/go/bin"
export PATH="$HOME/.govm/shim:$PATH"
export PATH="$HOME/.deno/bin:$PATH"
export PATH="$HOMEBREW_PATH/opt/postgresql@16/bin:$PATH"
RUSTUP_PATH=$(brew --prefix rustup)
export PATH="$RUSTUP_PATH/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# hack cli
# shellcheck disable=SC2139
alias hack="$HOME/dotfiles/packages/hack/src/cli.ts";
