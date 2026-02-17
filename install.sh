#!/bin/bash
# bph-installer - Intelligent Setup voor Bash Persistent History

BPH_SCRIPT="bph_setup.sh"
TARGET_FILE="$HOME/.bashrc"

echo "--- Installing Bash Persistent History ---"

if [ ! -f "$BPH_SCRIPT" ]; then
    echo "Fout: $BPH_SCRIPT niet gevonden!"
    exit 1
fi

cp "$BPH_SCRIPT" "$HOME/.bph_logic"

MARKER="# BPH-ACTIVATION-MARKER"
if grep -q "$MARKER" "$TARGET_FILE"; then
    echo "BPH is al aanwezig in $TARGET_FILE. Update uitgevoerd."
else
    echo "Nieuwe installatie: BPH toevoegen aan $TARGET_FILE..."
    cat <<EOT >> "$TARGET_FILE"

$MARKER
if [ -f "\$HOME/.bph_logic" ]; then
    source "\$HOME/.bph_logic"
fi
EOT
fi

echo "--- Installatie voltooid! ---"
