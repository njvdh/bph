#!/bin/bash
# bph-installer

BPH_SCRIPT="bph_setup.sh"
TARGET_FILE="$HOME/.bashrc"
BPH_LOGIC="$HOME/.bph_logic"
PH_LOG_DIR="$HOME/.phist"
PH_COMMAND_LOG="$PH_LOG_DIR/commands.log"

echo "--- Installing Bash Persistent History ---"

# 1. Prepare directory
mkdir -p "$PH_LOG_DIR"

# 2. Migration (if needed)
if [ ! -f "$PH_COMMAND_LOG" ] && [ -f "$HOME/.bash_history" ]; then
    echo "Importing existing .bash_history..."
    TODAY=$(date +%Y-%m-%d)
    NOW=$(date +%H:%M:%S)
    while read -r line; do
        echo -e "$TODAY\t$NOW\t$(hostname)\tlegacy\t0\t$line" >> "$PH_COMMAND_LOG"
    done < "$HOME/.bash_history"
fi

cp "$BPH_SCRIPT" "$BPH_LOGIC"

# 3. Add to .bashrc
MARKER="# BPH-ACTIVATION-MARKER"
if ! grep -q "$MARKER" "$TARGET_FILE"; then
    echo -e "\n$MARKER\nif [ -f \"$BPH_LOGIC\" ]; then source \"$BPH_LOGIC\"; fi" >> "$TARGET_FILE"
fi

echo "--- Installation complete! ---"
