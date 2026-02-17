# BPH - Bash Persistent History 📜

BPH ensures your Bash history is never lost. It saves commands immediately and shares history across multiple active sessions and containers.

## ✨ Features
- **Real-time storage:** Commands are written instantly.
- **Session sync:** Use a command in Terminal A, see it in Terminal B.
- **Persistence:** Perfect for LXD containers and Proxmox nodes.

## 🚀 Installation
```bash
git clone https://github.com/njvdh/bph.git
cd bph
chmod +x install.sh
./install.sh
```

## 📂 Structure
- `bph_setup.sh`: Core persistent history logic.
- `install.sh`: Intelligent installation script.

---
*Part of the [njvdh](https://github.com/njvdh) infrastructure tooling.*
