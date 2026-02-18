#!/bin/bash
# === BASH PERSISTENT HISTORY (V3.7 - Integrated) ===

# --- LOG SETTINGS ---
PH_LOG_DIR="$HOME/.phist"
PH_COMMAND_LOG="$PH_LOG_DIR/commands.log"
PH_SEPARATOR=$'\t'
MAX_CMD_LENGTH=2048
HISTTIMEFORMAT='%F %T '

# --- Multi-user Alert ---
USERS_COUNT=$(who | awk '{print $1}' | sort -u | wc -l)
if [ "$USERS_COUNT" -gt 1 ]; then
    echo -e "\e[1;33m[!] ATTENTION:\e[0m Multiple users logged in: $(who | awk '{print $1}' | sort -u | tr '\n' ' ')"
fi

# Function to view the persistent history (Your original 'h' function)
h ()
{
    if [ ! -f "$PH_COMMAND_LOG" ]; then
        echo "Persistent history logfile not found at: $PH_COMMAND_LOG"
        history
        return 0
    fi

    case $1 in
        "") history ;;
        m)
            if [ -z "$PHtty" ]; then
                echo "Warning: TTY unknown. Run a command first."
                return 1
            fi
            local TODAY=$(date +%Y-%m-%d)
            echo "--- Results for current TTY ($PHtty) and TODAY ($TODAY): ---"
            grep -F "$PH_SEPARATOR$PHtty$PH_SEPARATOR" "$PH_COMMAND_LOG" | grep -F "$TODAY$PH_SEPARATOR"
            ;;
        p) cat "$PH_COMMAND_LOG" ;;
        s)
            if [ -z "$2" ]; then echo "Usage: h s <term>"; return 1; fi
            echo "--- Results for '$2' in $PH_COMMAND_LOG: ---"
            grep -i "$2" "$PH_COMMAND_LOG"
            ;;
        *)
            cat <<_EOF
Usage: h <option>
m        current TTY for TODAY
p        full persistent history
s <term> search history
_EOF
            ;;
    esac
}

persistent_history ()
{
    local PHexit=$?
    local PHuser PHhost PHdate PHtime PHcmd PHcmd_len PHtty_val

    mkdir -p "$PH_LOG_DIR" 2>/dev/null

    # 1. Determine Identity
    read PHuser PHjunk PHhost <<< $(who am i 2>/dev/null | tr -d "[()]" | awk '{ print $1,$2,$NF }')
    PHtty=`tty | sed -e 's/\/dev\///'`
    [ -z "$PHuser" ] && PHuser=`id -nu`
    [ -z "$PHhost" ] && PHhost=`hostname -I 2>/dev/null | awk '{print $1}'`
    export PHtty

    # 2. Get Command and Timestamp
    [[ $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$ ]]
    PHdate_time="${BASH_REMATCH[1]}"
    PHcmd="${BASH_REMATCH[2]}"
    read PHdate PHtime <<< $(echo $PHdate_time)

    # 3. Prevent repetition and log
    if [ -n "$PHcmd" ] && [ "$PHcmd" != "$PERSISTENT_HISTORY_LAST" ]; then
        PHcmd_len=${#PHcmd}
        if [ "$PHcmd_len" -gt "$MAX_CMD_LENGTH" ]; then
            PHcmd="[DATA DUMP - $PHcmd_len bytes] $(echo "$PHcmd" | head -c 100)..."
        fi

        echo -e "$PHdate$PH_SEPARATOR$PHtime$PH_SEPARATOR$PHhost$PH_SEPARATOR$PHtty$PH_SEPARATOR$PHexit$PH_SEPARATOR$PHcmd" >> "$PH_COMMAND_LOG"
        export PERSISTENT_HISTORY_LAST="$PHcmd"
    fi

    # --- Ctrl+R Sync Logic ---
    history -a
    history -c
    history -r
}

# Aliases
alias l='ls -alF --group-directories-first'
alias ..='cd ..'
alias mc='unset DISPLAY; source /usr/lib/mc/mc-wrapper.sh'

# Activation
if [[ ! "$PROMPT_COMMAND" == *"persistent_history"* ]]; then
    export PROMPT_COMMAND="persistent_history; $PROMPT_COMMAND"
fi
