# if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
#   tmux attach-session -t main || tmux new-session -s main
# fi
if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]]; then
  tmux attach-session -t main || tmux new-session -s main
fi
