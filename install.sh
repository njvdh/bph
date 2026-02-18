#!/bin/bash
# bph-installer - Intelligent Setup for Bash Persistent History

BPH_SCRIPT="bph_setup.sh"
TARGET_FILE="$HOME/.bashrc"
BPH_LOGIC="$HOME/.bph_logic"

echo "--- Installing Bash Persistent History ---"

# 1. Migratie van oude .bash_history (alleen bij eerste keer)
if [ ! -f "$HOME/.phist" ] && [ -f "$HOME/.bash_history" ]; then
    echo "Importing existing .bash_history into BPH..."
    while read -r line; do
        echo "$(date "+%Y-%m-%d %H:%M:%S") [legacy@$(hostname)] [0] $line" >> "$HOME/.phist"
    done < "$HOME/.bash_history"
fi

# 2. Kopieer logica
cp "$BPH_SCRIPT" "$BPH_LOGIC"

# 3. Intelligent inplakken in .bashrc
MARKER="# BPH-ACTIVATION-MARKER"
if ! grep -q "$MARKER" "$TARGET_FILE"; then
    cat <<EOF >> "$TARGET_FILE"

$MARKER
if [ -f "$BPH_LOGIC" ]; then
    source "$BPH_LOGIC"
fi
EOF
fi

echo "--- Installation complete! ---"
