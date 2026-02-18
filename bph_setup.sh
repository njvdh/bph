#!/bin/bash
# BPH - Bash Persistent History Logic

# --- Multi-user Alert ---
USERS_COUNT=$(who | awk '{print $1}' | sort -u | wc -l)
if [ "$USERS_COUNT" -gt 1 ]; then
    echo -e "\e[1;33m[!] ATTENTION:\e[0m Multiple users logged in: $(who | awk '{print $1}' | sort -u | tr '\n' ' ')"
fi

persistent_history() {
    local exit_status=$?
    local last_cmd=$(history 1 | sed 's/^[ ]*[0-9]*[ ]*//')
    
    # Voorkom dubbele logs van lege commando's
    if [ -n "$last_cmd" ]; then
        # Schrijf naar de rijke .phist file (Metadata: Datum, Gebruiker@Host, ExitCode, Commando)
        echo "$(date "+%Y-%m-%d %H:%M:%S") [$(whoami)@$(hostname)] [$exit_status] $last_cmd" >> ~/.phist
    fi

    # --- De Ctrl+R Fix ---
    history -a # Schrijf huidige sessie direct naar .bash_history
    history -c # Maak interne buffer leeg
    history -r # Lees de gecombineerde file weer in (nu inclusief andere sessies)
}

# Activeer de functie bij elke prompt
export PROMPT_COMMAND="persistent_history; $PROMPT_COMMAND"
