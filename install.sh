#!/bin/bash
# === BASH PERSISTENT HISTORY INSTALLER (V3.7) ===

SETUP_FILE="bph_setup.sh"
TARGET_DIR="$HOME/.phist"
ALIAS_FILE="$HOME/.bash_aliases"

echo "Installing Bash Persistent History..."

# 1. Maak de log-map aan
mkdir -p "$TARGET_DIR"

# 2. Kopieer de setup naar de thuismap (verborgen)
cp "$SETUP_FILE" "$HOME/.$SETUP_FILE"
chmod +x "$HOME/.$SETUP_FILE"

# 3. Zorg voor de 'source' in .bash_aliases (of .bashrc als aliases niet bestaat)
if [ ! -f "$ALIAS_FILE" ]; then
    ALIAS_FILE="$HOME/.bashrc"
fi

if ! grep -q "$SETUP_FILE" "$ALIAS_FILE"; then
    echo "" >> "$ALIAS_FILE"
    echo "# Bash Persistent History Setup" >> "$ALIAS_FILE"
    echo "if [ -f \"\$HOME/.$SETUP_FILE\" ]; then . \"\$HOME/.$SETUP_FILE\"; fi" >> "$ALIAS_FILE"
    echo "Installation linked to $ALIAS_FILE"
else
    echo "Installation already linked in $ALIAS_FILE"
fi

echo "Done! Please run: source $ALIAS_FILE"
