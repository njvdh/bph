#!/bin/bash
# bph-installer - Setup Bash Persistent History

BPH_DIR="$HOME/.bph"
BPH_SCRIPT="bph_setup.sh"

echo "--- Installing Bash Persistent History ---"

# 1. Maak de directory aan voor de geschiedenisbestanden
mkdir -p "$BPH_DIR"

# 2. Kopieer het hoofdscript naar een vaste plek
cp "$BPH_SCRIPT" "$BPH_DIR/$BPH_SCRIPT"

# 3. Voeg de activatie-regel toe aan .bashrc als die er nog niet in staat
LINE="source $BPH_DIR/$BPH_SCRIPT"
if ! grep -qF "$LINE" "$HOME/.bashrc"; then
    echo "$LINE" >> "$HOME/.bashrc"
    echo "Added BPH to ~/.bashrc"
else
    echo "BPH already present in ~/.bashrc"
fi

echo "--- Installation complete! ---"
echo "Restart your terminal or run: source ~/.bashrc"
