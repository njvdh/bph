# Bash Persistent History (BPH) V3.7

BPH is a lightweight, robust tool for system administrators to capture and search command history across multiple sessions, users, and environments.

> **Project Status: Beta / Work in Progress** > This tool is part of an ongoing development series. While the core history features are stable, other infrastructure scripts in this repository may be subject to frequent updates.

## Key Features

* **Advanced Persistence:** Logs commands with exit codes, timestamps, TTY, and source IP to `~/.phist/commands.log`.
* **Multi-user Alert:** Notifies you upon login if other administrators are active.
* **Data-dump Protection:** Automatically truncates commands longer than 2048 bytes to prevent log pollution.
* **Automated Retention:** Keeps your disk clean by purging logs older than 365 days.
* **The `h` Tool:** A powerful helper function for searching your history.

## Logging Logic: Actions vs. Data

BPH logs **actions**, not **payloads**.
* **Logged:** The command `cat > secret.txt` is recorded.
* **Not Logged:** The actual content piped or typed into the file (STDIN) is ignored to ensure privacy and clean logs.

## Installation & Usage

### For New Users:
1. **Clone the repository:**
   ```bash
   git clone [https://github.com/njvdh/bph.git](https://github.com/njvdh/bph.git)
   cd bph
