# ZshStyle Installer

Automated Zsh environment setup script for macOS and Debian/Ubuntu Linux systems.

---

## 🚀 Features

- ✅ Detects OS and CPU architecture
- ✅ Installs essential CLI tools:
  - `zsh`, `git`, `curl`, `nano`, `fzf`, `grc`, `gnupg`
  - `bat` and `eza` with architecture-aware `.deb` install (Debian/Ubuntu)
- ✅ Installs and configures [Oh My Zsh](https://ohmyz.sh/)
- ✅ Clones and updates custom Zsh plugins:
  - `zsh-syntax-highlighting`
  - `zsh-autosuggestions`
  - `zsh-you-should-use`
  - `zsh-bat`
  - `zsh-eza`
- ✅ Sets up Powerlevel10k theme and downloads custom configs from GitHub
- ✅ Symlinks Zsh configs to root user
- ✅ Fully idempotent (safe to re-run)

---

## 🧰 Requirements

- macOS or Debian/Ubuntu-based Linux
- `bash`
- Internet connection

---

## 📦 Installation

```bash
git clone https://github.com/yourusername/ZshStyleInstaller.git
cd ZshStyleInstaller
chmod +x install_zsh_env.sh
./install_zsh_env.sh
```

> ℹ️ The script will prompt nothing and execute automatically with logging output.

---

## 🔧 Custom Configs

The following configuration files are downloaded automatically:

- `.zshrc`: [View on GitHub](https://github.com/New8ie/ZshStyle/blob/main/zsh/.zshrc)
- `.p10k.zsh`: [View on GitHub](https://github.com/New8ie/ZshStyle/blob/main/zsh/.p10k.zsh)
- `.zprofile`: [View on GitHub](https://github.com/New8ie/ZshStyle/blob/main/zsh/.zprofile)

You can fork the config repo and change the links in `install_zsh_env.sh` if you want to customize it further.

---

## 🧪 Tested On

- ✅ macOS Ventura (Intel & Apple Silicon)
- ✅ Debian 12 Bookworm
- ✅ Ubuntu 22.04 LTS

---

## 🛠 Troubleshooting

- If you see `Oh My Zsh already exists`, the script will skip reinstalling it.
- Plugin errors will be skipped if folders already exist.
- For `batcat`, a symlink is created to use `bat` instead.
- Re-run the script anytime safely.

---

## 📝 License

MIT License

---

## 🙏 Credits

Inspired by personal workflows and the Zsh plugin community ❤️

---

Feel free to open issues or contribute by pull requests!

