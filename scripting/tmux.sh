# NOTE: bunch of nice things for tmux

# allow switching tmux sessions with ctrl + p and ctrl + n
function switch_tmux_window_prev {
  if [[ -n "$TMUX" ]]; then
    # Switch to the next session
    tmux switch-client -p
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

# Bind a key to invoke the custom function
bindkey -s ^f "tmux-sessionizer\n"
