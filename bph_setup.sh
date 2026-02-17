# === BASH PERSISTENT HISTORY (V3.6) ===
#
# GitHub: https://github.com/njvdh/Bash-persistent-history
#
# Stop if this is not a Bash shell
if [ `basename $SHELL` != "bash" ]; then exit; fi

# Adjust PATH
PATH=$HOME/bin:/local/bin:$PATH

# --- LOG SETTINGS ---
PH_LOG_DIR="$HOME/.phist"
PH_COMMAND_LOG="$PH_LOG_DIR/commands.log"
PH_SEPARATOR=$'\t'
MAX_CMD_LENGTH=2048

# Set the time format for the standard Bash history
HISTTIMEFORMAT='%F %T '

# Function to view the persistent history
h ()
{
    # Check if the log file exists
    if [ ! -f "$PH_COMMAND_LOG" ]; then
        echo "Persistent history logfile not found at: $PH_COMMAND_LOG"
        history
        return 0
    fi

    case $1 in
        "")
            history
            ;;
        m)
            # Default filter: TODAY and the current TTY.
            if [ -z "$PHtty" ]; then
                echo "Warning: TTY session value is unknown. Run a command first or log in again."
                return 1
            fi
            
            # Determine today's date in log format
            local TODAY=$(date +%Y-%m-%d)
            
            # Step 1: Filter by the current TTY ($PHtty)
            local search_results=$(grep -F "$PH_SEPARATOR$PHtty$PH_SEPARATOR" "$PH_COMMAND_LOG")
            
            # Step 2: Filter the TTY results by TODAY
            echo "--- Results for the current TTY ($PHtty) and TODAY ($TODAY): ---"
            echo "$search_results" | grep -F "$TODAY$PH_SEPARATOR"
            ;;
        p)
            # Display the full persistent history
            cat "$PH_COMMAND_LOG"
            ;;
        s)
            if [ -z "$2" ]; then
                echo "Error: Provide a search term for the search function (h s <term>)."
                return 1
            fi
            # Search the full history (case-insensitive)
            echo "--- Results for '$2' in $PH_COMMAND_LOG: ---"
            grep -i "$2" "$PH_COMMAND_LOG"
            ;;
        *)
            cat <<_EOF
Usage: h <option>, where option is:
<none>   standard Bash history
m        my personal persistent history (current TTY) for TODAY
p        full persistent history
s <term> search the full persistent history (case-insensitive)
_EOF
            ;;
    esac
}

### PERSISTENT HISTORY MAIN FUNCTION
PROMPT_COMMAND="persistent_history"
persistent_history ()
{
    local PHexit=$?
    # PHtty is not localized so it can be exported.
    local PHexit PHuser PHhost PHdate PHtime PHcmd PHcmd_len

    # Ensure the log directory exists
    mkdir -p "$PH_LOG_DIR" 2>/dev/null

    # 1. Determine User, TTY, and Host
    # Get User and Host, but fetch TTY separately for unique session ID (pts/X).
    read PHuser PHjunk PHhost <<< $(who am i 2>/dev/null | tr -d "[()]" | awk '{ print $1,$2,$NF }')

    # Force TTY determination to the unique pts/X or ttyX value
    PHtty=`tty | sed -e 's/\/dev\///'`

    # Fallbacks
    if [ -z "$PHuser" ]; then PHuser=`id -nu`; fi
    if [ -z "$PHhost" ]; then PHhost=`hostname -I 2>/dev/null | awk '{print $1}'`; fi
    if [ -z "$PHhost" ]; then PHhost="UNKNOWN_IP"; fi
    
    # EXPORT the determined, unique TTY so h m can use it
    export PHtty

    # 2. Get Command and Timestamp from Bash history
    [[ $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$ ]]
    PHdate_time="${BASH_REMATCH[1]}"
    PHcmd="${BASH_REMATCH[2]}"
    
    # Split the date and time
    read PHdate PHtime <<< $(echo $PHdate_time)

    # 3. Prevent command repetition and log
    if [ -n "$PHcmd" ] && [ "$PHcmd" != "$PERSISTENT_HISTORY_LAST" ]
    then
        PHcmd_len=${#PHcmd}

        if [ "$PHcmd_len" -gt "$MAX_CMD_LENGTH" ]; then
            # Command is too long (likely data-dump/paste). Log the length and a snippet.
            PHcmd="[DATA DUMP/PASTE - LENGTH: $PHcmd_len bytes] $(echo "$PHcmd" | head -c 100)..."
        fi

        # Log format: Date \t Time \t Host \t TTY \t ExitStatus \t Command
        echo -e "$PHdate$PH_SEPARATOR$PHtime$PH_SEPARATOR$PHhost$PH_SEPARATOR$PHtty$PH_SEPARATOR$PHexit$PH_SEPARATOR$PHcmd" >> "$PH_COMMAND_LOG"
        export PERSISTENT_HISTORY_LAST="$PHcmd"
    fi
}

# === ALIASES ===
alias l='ls -alF --group-directories-first'
alias ..='cd ..'
# Activate the mc alias to ensure TUI mode, even in a graphical terminal
alias mc='unset DISPLAY; source /usr/lib/mc/mc-wrapper.sh'
