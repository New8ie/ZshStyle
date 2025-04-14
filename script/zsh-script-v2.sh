#!/usr/bin/env bash
set -euo pipefail

### ========= Logging Utility ========= ###
log()  { echo -e "\033[1;32m[INFO]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
err()  { echo -e "\033[1;31m[ERROR]\033[0m $*" >&2; exit 1; }

### ========= Deteksi OS & Arsitektur ========= ###
detect_os_arch() {
    OS_TYPE=""
    ARCH_TYPE="$(uname -m)"

    case "$(uname)" in
        Darwin) OS_TYPE="macos" ;;
        Linux)
            if [ -f /etc/debian_version ]; then
                OS_TYPE="debian"
            else
                err "OS Linux ini belum didukung (bukan Debian/Ubuntu)."
            fi
            ;;
        *) err "OS $(uname) belum didukung." ;;
    esac

    log "Mendeteksi OS: $OS_TYPE"
    log "Mendeteksi Arsitektur: $ARCH_TYPE"
}

### ========= Install Paket ========= ###
install_packages() {
    if [ "$OS_TYPE" = "macos" ]; then
        if ! command -v brew &>/dev/null; then
            log "Menginstall Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install zsh git curl nano bat fzf grc gnupg eza
    elif [ "$OS_TYPE" = "debian" ]; then
        sudo apt update
        sudo apt install -y zsh git curl nano fzf grc gnupg 
        install_bat_deb
        install_eza_deb
    fi
}

### ========= Install bat dari GitHub Release ========= ###
install_bat_deb() {
    log "Menginstall bat (.deb manual)..."

    ARCH_DEB=""
    case "$ARCH_TYPE" in
        x86_64) ARCH_DEB="amd64" ;;
        aarch64 | arm64) ARCH_DEB="arm64" ;;
        *) err "Arsitektur tidak dikenali untuk bat." ;;
    esac

    VERSION="0.24.0"
    FILENAME="bat_${VERSION}_${ARCH_DEB}.deb"
    URL="https://github.com/sharkdp/bat/releases/download/v${VERSION}/${FILENAME}"
    TEMP_DEB="/tmp/$FILENAME"

    curl -fL -o "$TEMP_DEB" "$URL" || err "Gagal mengunduh bat .deb"
    sudo dpkg -i "$TEMP_DEB" || sudo apt install -f -y
    rm -f "$TEMP_DEB"

    # Symlink batcat ke bat jika perlu
    if [ -f "/usr/bin/batcat" ] && [ ! -f "/usr/local/bin/bat" ]; then
        sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
    fi
}

### ========= Install eza dari .deb ========= ###
install_eza_deb() {
    log "Menginstall eza (.deb manual)..."

    ARCH_DEB=""
    case "$ARCH_TYPE" in
        x86_64) ARCH_DEB="amd64" ;;
        aarch64 | arm64) ARCH_DEB="arm64" ;;
        *) err "Arsitektur tidak dikenali untuk eza." ;;
    esac

    VERSION="0.20.9"
    FILENAME="eza_${VERSION}_${ARCH_DEB}.deb"
    URL="https://deb.gierens.de/pool/main/e/eza/$FILENAME"
    TEMP_DEB="/tmp/$FILENAME"

    curl -fL -o "$TEMP_DEB" "$URL" || err "Gagal mengunduh eza .deb"
    sudo dpkg -i "$TEMP_DEB" || sudo apt install -f -y
    rm -f "$TEMP_DEB"
}

### ========= Install Oh My Zsh ========= ###
install_oh_my_zsh() {
    export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
    export ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

    if [ -d "$ZSH" ]; then
        log "Folder Oh My Zsh sudah ada di $ZSH, lewati instalasi."
    else
        log "Menginstall Oh My Zsh..."
        export RUNZSH=no
        export CHSH=no
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
}

### ========= Clone Plugin Zsh ========= ###
clone_plugin() {
    local repo_url="$1"
    local plugin_dir="$2"

    if [ -d "$plugin_dir/.git" ]; then
        log "Plugin $(basename "$plugin_dir") sudah ada, update..."
        git -C "$plugin_dir" pull --quiet || warn "Gagal update plugin $(basename "$plugin_dir")"
    elif [ -d "$plugin_dir" ]; then
        warn "Direktori $plugin_dir sudah ada tapi bukan repo git. Lewati."
    else
        log "Clone plugin $(basename "$plugin_dir")..."
        git clone --depth=1 "$repo_url" "$plugin_dir" || warn "Gagal clone plugin $(basename "$plugin_dir")"
    fi
}

clone_plugins() {
    log "Meng-clone plugin-plugin Zsh..."
    clone_plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    clone_plugin "https://github.com/zsh-users/zsh-autosuggestions.git" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    clone_plugin "https://github.com/MichaelAquilina/zsh-you-should-use.git" "$ZSH_CUSTOM/plugins/zsh-you-should-use"
    clone_plugin "https://github.com/fdellwing/zsh-bat.git" "$ZSH_CUSTOM/plugins/zsh-bat"
    clone_plugin "https://github.com/z-shell/zsh-eza.git" "$ZSH_CUSTOM/plugins/zsh-eza"
}

### ========= Setup Powerlevel10k + Config ========= ###
setup_powerlevel10k() {
    log "Menginstall Powerlevel10k..."
    clone_plugin "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM/themes/powerlevel10k"

    log "Mengunduh konfigurasi zsh..."
    curl -fsSL -o "$HOME/.zshrc" https://raw.githubusercontent.com/New8ie/ZshStyle/refs/heads/main/zsh/.zshrc
    curl -fsSL -o "$HOME/.p10k.zsh" https://raw.githubusercontent.com/New8ie/ZshStyle/refs/heads/main/zsh/.p10k.zsh
    curl -fsSL -o "$HOME/.zprofile" https://raw.githubusercontent.com/New8ie/ZshStyle/refs/heads/main/zsh/.zprofile
}

### ========= Symlink untuk Root User ========= ###
create_symlinks_for_root() {
    log "Membuat symlink konfigurasi untuk root..."

    sudo ln -sf "$HOME/.oh-my-zsh" /root/.oh-my-zsh
    sudo ln -sf "$HOME/.zshrc" /root/.zshrc
    sudo ln -sf "$HOME/.p10k.zsh" /root/.p10k.zsh
    sudo ln -sf "$HOME/.config" /root/.config
    sudo ln -sf "$HOME/.local" /root/.local
}

### ========= Eksekusi Utama ========= ###
main() {
    detect_os_arch
    install_packages
    install_oh_my_zsh
    clone_plugins
    setup_powerlevel10k
    create_symlinks_for_root

    log "✅ Instalasi Zsh environment selesai!"
    log "Jalankan: \033[1mzsh\033[0m untuk mulai menggunakan."
}

main "$@"
