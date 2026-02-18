# Bash Persistent History (BPH) V3.7

A robust solution for system administrators to capture and search command history across multiple sessions, users, and reboots.

## Core Features

* **Reliable Persistence:** All commands are logged with exit code, timestamp, TTY, and source IP to `~/.phist/commands.log`.
* **Multi-user Alert:** Notifies you upon login if other administrators are currently active on the system.
* **Data-dump Protection:** Prevents log bloating by truncating commands longer than 2048 bytes (ideal for accidental pastes of RSA keys or large scripts).
* **Automatic Retention:** Automatically purges log files older than 365 days (checked hourly) to keep disk usage predictable.
* **Ctrl+R Sync:** Instantly synchronizes history between concurrent terminal windows.
* **The `h` Tool:** A specialized function to search and manage your history efficiently.

## Logging Logic: Actions vs. Data

BPH is designed to log **actions**, not **data streams**.

* **What is logged:** The command itself. For example, if you run `cat > config.conf`, the command is recorded so you know *when* the file was modified.
* **What is NOT logged:** The content you type or paste into the file (STDIN) after the command. This ensures your logs remain readable and prevents sensitive data from being stored in plain text history.

## Usage: The `h` Command

| Command | Action |
| :--- | :--- |
| `h` | Displays the standard Bash history. |
| `h p` | Displays the full persistent log (`commands.log`). |
| `h s <term>` | Searches the log for a specific term (case-insensitive). |
| `h m` | Shows today's results for the current TTY only. |
| `h dumps` | Shows all intercepted "Data Dumps" (oversized commands). |

## Installation

1. Clone this repository.
2. Run `./install.sh`.
3. Reload your environment: `source ~/.bashrc`.
