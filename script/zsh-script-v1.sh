#!/usr/bin/env bash

set -euo pipefail

# Logging
log() {
    echo -e "\033[1;32m[INFO]\033[0m $1"
}
err() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
    exit 1
}

# Deteksi OS & arsitektur
OS="$(uname -s)"
ARCH="$(uname -m)"

log "Mendeteksi OS: $OS"
log "Mendeteksi Arsitektur: $ARCH"

case "$OS" in
    Darwin)
        OS_TYPE="macos"
        ;;
    Linux)
        if [ -f /etc/debian_version ]; then
            OS_TYPE="debian"
        else
            err "Linux ini bukan berbasis Debian/Ubuntu."
        fi
        ;;
    *)
        err "Sistem operasi tidak dikenali."
        ;;
esac

install_eza_deb() {
    log "Mengunduh dan menginstal eza dari file .deb (gierens.de)..."

    ARCH_DEB=""
    case "$(uname -m)" in
        x86_64)
            ARCH_DEB="amd64"
            ;;
        aarch64 | arm64)
            ARCH_DEB="arm64"
            ;;
        *)
            err "Arsitektur tidak didukung untuk instalasi eza"
            ;;
    esac

    VERSION="0.20.9"
    FILENAME="eza_${VERSION}_${ARCH_DEB}.deb"
    DOWNLOAD_URL="https://deb.gierens.de/pool/main/e/eza/$FILENAME"
    TEMP_DEB="/tmp/$FILENAME"

    log "Mengunduh dari: $DOWNLOAD_URL"
    if ! curl -fL -o "$TEMP_DEB" "$DOWNLOAD_URL"; then
        err "Gagal mengunduh file .deb dari $DOWNLOAD_URL"
    fi

    log "Menginstall eza..."
    if ! sudo dpkg -i "$TEMP_DEB"; then
        log "dpkg gagal, mencoba memperbaiki dependency..."
        sudo apt install -f -y || err "Gagal memperbaiki dependensi dpkg"
    fi

    rm -f "$TEMP_DEB"
}

# Update dan install paket
install_packages() {
    log "Menginstall dependency utama..."

    if [ "$OS_TYPE" == "macos" ]; then
        if ! command -v brew >/dev/null; then
            log "Homebrew tidak ditemukan. Menginstall Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install zsh git curl nanorc bat fzf grc gnupg eza
    elif [ "$OS_TYPE" == "debian" ]; then
    sudo apt update
    sudo apt install -y zsh git curl nano bat fzf grc gnupg

    install_eza_deb

    fi
}

# Install Oh My Zsh
install_ohmyzsh() {
    log "Menginstall Oh My Zsh..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
}

# Clone plugins
clone_plugin() {
    local repo_url="$1"
    local plugin_dir="$2"

    if [ -d "$plugin_dir/.git" ]; then
        log "Plugin $(basename "$plugin_dir") sudah ada, melakukan git pull..."
        git -C "$plugin_dir" pull --quiet && log "Berhasil update plugin $(basename "$plugin_dir")" || log "Gagal update plugin $(basename "$plugin_dir")"

    elif [ -d "$plugin_dir" ]; then
        log "Direktori $plugin_dir sudah ada tapi bukan git repo. Lewati clone."
    else
        log "Meng-clone plugin $(basename "$plugin_dir")..."
        git clone --depth=1 "$repo_url" "$plugin_dir" || log "Gagal clone plugin $(basename "$plugin_dir")"
    fi
}

# Pastikan ZSH dir dan ZSH_CUSTOM diset
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
export ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

clone_plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_plugin "https://github.com/zsh-users/zsh-autosuggestions.git" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_plugin "https://github.com/MichaelAquilina/zsh-you-should-use.git" "$ZSH_CUSTOM/plugins/zsh-you-should-use"
clone_plugin "https://github.com/fdellwing/zsh-bat.git" "$ZSH_CUSTOM/plugins/zsh-bat"
clone_plugin "https://github.com/z-shell/zsh-eza.git" "$ZSH_CUSTOM/plugins/zsh-eza"


# Install theme Powerlevel10k
install_theme() {
    log "Menginstall tema Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
}

# Ambil file konfigurasi dari GitHub
apply_configs() {
    log "Mengunduh file konfigurasi .zshrc, .zprofile, .p10k.zsh..."

    curl -fsSL -o "$HOME/.zshrc" https://raw.githubusercontent.com/New8ie/ZshStyle/refs/heads/main/zsh/.zshrc
    curl -fsSL -o "$HOME/.zprofile" https://raw.githubusercontent.com/New8ie/ZshStyle/refs/heads/main/zsh/.zprofile
    curl -fsSL -o "$HOME/.p10k.zsh" https://raw.githubusercontent.com/New8ie/ZshStyle/refs/heads/main/zsh/.p10k.zsh
}

# Buat symlink konfigurasi untuk root
link_for_root() {
    log "Membuat symlink konfigurasi ke root..."

    sudo ln -sf "$HOME/.oh-my-zsh" /root/.oh-my-zsh
    sudo ln -sf "$HOME/.zshrc" /root/.zshrc
    sudo ln -sf "$HOME/.p10k.zsh" /root/.p10k.zsh
    sudo ln -sf "$HOME/.config" /root/.config
    sudo ln -sf "$HOME/.local" /root/.local
}

# Eksekusi semua
main() {
    install_packages
    install_ohmyzsh
    clone_plugins
    install_theme
    apply_configs
    link_for_root
    log "Selesai! Silakan restart shell Anda atau jalankan 'zsh'."
}

main "$@"
