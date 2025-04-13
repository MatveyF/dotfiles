#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/work ~/projects ~/PycharmProjects ~/ ~/personal -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

# Function to create venv activation command with fallbacks
create_venv_command() {
    local dir=$1
    echo "if [ -f $dir/.venv/bin/activate ]; then
            source $dir/.venv/bin/activate && clear && which python
          elif [ -f $dir/venv/bin/activate ]; then
            source $dir/venv/bin/activate && clear && which python
          elif [ -f $dir/backend/.venv/bin/activate ]; then
            source $dir/backend/.venv/bin/activate && clear && which python
          elif [ -f $dir/backend/venv/bin/activate ]; then
            source $dir/backend/venv/bin/activate && clear && which python
          else
            clear && echo 'No Python virtual environment found'
          fi"
}

VENV_COMMAND=$(create_venv_command "$selected")

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    # Create new session with three windows when starting fresh
    tmux new-session -s $selected_name -c $selected \; send-keys "$VENV_COMMAND" C-m \; \
        new-window -n "lazygit" -c $selected \; send-keys "$VENV_COMMAND && if command -v lazygit >/dev/null 2>&1; then lazygit; else echo 'lazygit not installed'; fi" C-m \; \
        new-window -c $selected \; send-keys "$VENV_COMMAND" C-m \; \
        select-window -t 1
    exit 0
fi

if ! tmux has-session -t=$selected_name 2>/dev/null; then
    # Create detached session with three windows when attaching
    tmux new-session -ds $selected_name -c $selected \; send-keys "$VENV_COMMAND" C-m \; \
        new-window -n "lazygit" -c $selected \; send-keys "$VENV_COMMAND && if command -v lazygit >/dev/null 2>&1; then lazygit; else echo 'lazygit not installed'; fi" C-m \; \
        new-window -c $selected \; send-keys "$VENV_COMMAND" C-m \; \
        select-window -t 1
fi

tmux switch-client -t $selected_name
