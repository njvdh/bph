#!/bin/bash
# === BASH PERSISTENT HISTORY (V3.7 - COMPLEET) ===

# --- CONFIGURATIE ---
PH_LOG_DIR="$HOME/.phist"
PH_COMMAND_LOG="$PH_LOG_DIR/commands.log"
PH_SEPARATOR=$'\t'
MAX_CMD_LENGTH=2048       # De check die je al had tegen data-dumps
RETENTION_DAYS=365        # De retentie die we nu heractiveren
HISTTIMEFORMAT='%F %T '

# --- 1. MULTI-USER ALERT ---
USERS_COUNT=$(who | awk '{print $1}' | sort -u | wc -l)
if [ "$USERS_COUNT" -gt 1 ]; then
    echo -e "\e[1;33m[!] ATTENTION:\e[0m Multiple administrators logged in: $(who | awk '{print $1}' | sort -u | tr '\n' ' ')"
fi

# --- 2. DE 'H' FUNCTIE (ZOEKEN) ---
h () {
    if [ ! -f "$PH_COMMAND_LOG" ]; then
        echo "Logfile not found at: $PH_COMMAND_LOG"; history; return 0
    fi
    case $1 in
        "") history ;;
        m)  local TODAY=$(date +%Y-%m-%d)
            echo "--- Results for TTY ($PHtty) on ($TODAY): ---"
            grep -F "$PH_SEPARATOR$PHtty$PH_SEPARATOR" "$PH_COMMAND_LOG" | grep -F "$TODAY$PH_SEPARATOR" ;;
        p)  cat "$PH_COMMAND_LOG" ;;
        s)  [ -z "$2" ] && echo "Usage: h s <term>" || grep -i "$2" "$PH_COMMAND_LOG" ;;
        *)  echo "Usage: h [m|p|s <term>]" ;;
    esac
}

# --- 3. DE HOOFDFUNCTIE ---
persistent_history () {
    local PHexit=$?
    local PHuser PHhost PHdate PHtime PHcmd PHcmd_len

    mkdir -p "$PH_LOG_DIR" 2>/dev/null

    # Identiteit en TTY (Jou eigen V3.6 methode)
    read PHuser PHjunk PHhost <<< $(who am i 2>/dev/null | tr -d "[()]" | awk '{ print $1,$2,$NF }')
    PHtty=`tty | sed -e 's/\/dev\///'`
    [ -z "$PHuser" ] && PHuser=`id -nu`
    [ -z "$PHhost" ] && PHhost=`hostname -I 2>/dev/null | awk '{print $1}'`
    export PHtty

    # Pak commando en tijd uit Bash history
    [[ $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$ ]]
    PHdate_time="${BASH_REMATCH[1]}"
    PHcmd="${BASH_REMATCH[2]}"
    read PHdate PHtime <<< $(echo $PHdate_time)

    # Voorkom herhaling en pas lengte-beveiliging toe
    if [ -n "$PHcmd" ] && [ "$PHcmd" != "$PERSISTENT_HISTORY_LAST" ]; then
        PHcmd_len=${#PHcmd}
        if [ "$PHcmd_len" -gt "$MAX_CMD_LENGTH" ]; then
            PHcmd="[DATA DUMP - $PHcmd_len bytes] $(echo "$PHcmd" | head -c 100)..."
        fi

        # Loggen met TAB-separatie
        echo -e "$PHdate$PH_SEPARATOR$PHtime$PH_SEPARATOR$PHhost$PH_SEPARATOR$PHtty$PH_SEPARATOR$PHexit$PH_SEPARATOR$PHcmd" >> "$PH_COMMAND_LOG"
        export PERSISTENT_HISTORY_LAST="$PHcmd"
    fi

    # --- 4. RETENTIE (MAANDELIJKSE OPRUIMING) ---
    # We doen dit alleen bij de eerste commando van de dag om vertraging te voorkomen
    if [ "$(date +%M)" == "00" ]; then # Check bijv. één keer per uur (minuut 00)
        find "$PH_LOG_DIR" -name "*.log" -mtime +$RETENTION_DAYS -delete 2>/dev/null
    fi

    # --- 5. SYNC (CTRL+R) ---
    history -a
    history -c
    history -r
}

# Aliases
alias l='ls -alF --group-directories-first'
alias ..='cd ..'
alias mc='unset DISPLAY; source /usr/lib/mc/mc-wrapper.sh'

# Activering
if [[ ! "$PROMPT_COMMAND" == *"persistent_history"* ]]; then
    export PROMPT_COMMAND="persistent_history; $PROMPT_COMMAND"
fi
