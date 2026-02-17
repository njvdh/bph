#!/bin/bash
# bph-installer - Intelligent Setup for Bash Persistent History

BPH_SCRIPT="bph_setup.sh"
TARGET_FILE="$HOME/.bashrc"

echo "--- Installing Bash Persistent History ---"

if [ ! -f "$BPH_SCRIPT" ]; then
    echo "Error: $BPH_SCRIPT not found!"
    exit 1
fi

cp "$BPH_SCRIPT" "$HOME/.bph_logic"

MARKER="# BPH-ACTIVATION-MARKER"
if grep -q "$MARKER" "$TARGET_FILE"; then
    echo "BPH is already present in $TARGET_FILE. Logic updated."
else
    echo "New installation: Adding BPH to $TARGET_FILE..."
    cat <<EOT >> "$TARGET_FILE"

$MARKER
if [ -f "\$HOME/.bph_logic" ]; then
    source "\$HOME/.bph_logic"
fi
EOT
fi

echo "--- Installation complete! ---"
echo "Please restart your terminal or run: source ~/.bashrc"
