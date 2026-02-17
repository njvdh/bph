# BPH - Bash Persistent History 📜

BPH ensures your Bash history is never lost. It saves commands immediately and shares history across multiple active sessions and containers.

## ✨ Features
- **Real-time storage:** Commands are written instantly.
- **Session sync:** Use a command in Terminal A, see it in Terminal B.
- **Persistence:** Perfect for LXD containers and Proxmox nodes.

## 🚀 Installation
> [!IMPORTANT]
> **Migration Note:** If you previously manually added BPH code to your `~/.bashrc` or `~/.bash_aliases`, please remove those entries before running the installer to avoid duplicate logic.

```bash
git clone [https://github.com/njvdh/bph.git](https://github.com/njvdh/bph.git)
cd bph
chmod +x install.sh
./install.sh

> [!IMPORTANT]
> **Migration Note:** If you previously manually added BPH code to your `~/.bashrc` or `~/.bash_aliases`,<b>
> please remove those entries before running the installer to avoid duplicate logic.<b>
```

## 📂 Structure
- `bph_setup.sh`: Core persistent history logic.
- `install.sh`: Intelligent installation script.

---
*Part of the [njvdh](https://github.com/njvdh) infrastructure tooling.*
