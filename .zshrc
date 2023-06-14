# Set up zsh
export ZSH="$HOME/.oh-my-zsh"

# good zsh theme
ZSH_THEME="murilasso"

# Load any cool plugins
plugins=(
  git
  nvm
  history
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# load brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# load zsh
source $ZSH/oh-my-zsh.sh

# good fuzzy
source $HOME/.fzf.zsh

# profile
source $HOME/.zprofile

# load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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

# op cli plugins
source "$HOME/.config/op/plugins.sh"

# add bins to path
export PATH="$HOME/bin:$PATH"

# clear the suggestion with ctrl + space
bindkey '^ ' autosuggest-clear

# allow switching tmux sessions with ctrl + p and ctrl + n
function switch_tmux_window_prev {
  if [[ -n "$TMUX" ]]; then
    # Switch to the next session
    tmux switch-client -n
  else
    echo "Not inside a tmux session."
  fi
}

function switch_tmux_window_next {
  if [[ -n "$TMUX" ]]; then
    # Switch to the next session
    tmux switch-client -n
  else
    echo "Not inside a tmux session."
  fi
}

zle -N switch_tmux_window_prev
zle -N switch_tmux_window_next
bindkey '^p' switch_tmux_window_prev
bindkey '^n' switch_tmux_window_next

# bind control-t to make a tmux session and switch to it
function new_tmux_session {
  if [[ -n "$TMUX" ]]; then
    # create new tmux detached session then switch to it
    sessionUnixDateName="Untitled ($(date +%s))"
    tmux new-session -d -s "$sessionUnixDateName"
    tmux switch-client -t "$sessionUnixDateName"
  else
    echo "Not inside a tmux session."
  fi
}

zle -N new_tmux_session
bindkey '^t' new_tmux_session
