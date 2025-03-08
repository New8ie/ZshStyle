#!/bin/bash

# **1. Install Dependensi Dasar**
echo "📦 Menginstal dependensi dasar..."
sudo apt update && sudo apt install -y git curl wget gpg || {
  echo "❌ Gagal menginstal dependensi!"
  exit 1
}

# **2. Install Zsh**
echo "🚀 Menginstal Zsh..."
sudo apt install -y zsh || {
  echo "❌ Gagal menginstal Zsh"
  exit 1
}

# **3. Install CLI Tools (Eza, Bat, dll.)**
echo "🛠️ Menginstal CLI Tools..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo apt install -y gpg
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg || {
    echo "❌ Gagal mengunduh GPG key, menggunakan paket alternatif..."
    sudo rm -f /etc/apt/sources.list.d/gierens.list
    wget -O /tmp/eza.deb https://github.com/New8ie/ZshStyle/raw/refs/heads/main/source/eza_0.20.9_amd64.deb || {
      echo "❌ Gagal mengunduh paket eza"
      exit 1
    }
    sudo dpkg -i /tmp/eza.deb || {
      echo "❌ Gagal menginstal eza"
      exit 1
    }
  }
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update && sudo apt install -y eza || echo "⚠️ Gagal menginstal eza dari repositori, sudah menggunakan paket lokal."
fi

# **4. Install Oh-My-Zsh (jika belum terinstal)**
echo "🚀 Mengecek instalasi Oh-My-Zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "✅ Oh-My-Zsh sudah terinstal. Melewati langkah ini."
else
  echo "📥 Menginstal Oh-My-Zsh..."
  sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh || curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# **5. Install Plugins Oh-My-Zsh**
echo "🔌 Menginstal Plugin Zsh..."
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$ZSH_CUSTOM/plugins/zsh-you-should-use"
git clone https://github.com/fdellwing/zsh-bat.git "$ZSH_CUSTOM/plugins/zsh-bat"
git clone https://github.com/z-shell/zsh-eza.git "$ZSH_CUSTOM/plugins/zsh-eza"

# **6. Install powerlevel10k**
echo "🎨 Menginstal Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# **7. Mengunduh & Mengatur Konfigurasi Zsh**
echo "⚙️ Mengunduh konfigurasi Zsh..."
wget -O $HOME/.zshrc https://raw.githubusercontent.com/New8ie/ZshStyle/refs/heads/main/zsh/.zshrc
wget -O $HOME/.zprofile https://raw.githubusercontent.com/New8ie/ZshStyle/refs/heads/main/zsh/.zprofile
wget -O $HOME/.p10k.zsh https://raw.githubusercontent.com/New8ie/ZshStyle/refs/heads/main/zsh/.p10k.zsh

# **8. Konfigurasi untuk Root**
echo "🔗 Membuat symlink konfigurasi untuk root..."
sudo ln -s $HOME/.oh-my-zsh /root/.oh-my-zsh
sudo ln -s $HOME/.zshrc /root/.zshrc
sudo ln -s $HOME/.p10k.zsh /root/.p10k.zsh
sudo ln -s $HOME/.config /root/.config
sudo ln -s $HOME/.local /root/.local

# **9. Finalisasi & Restart Shell**
echo "✅ Instalasi selesai! Silakan jalankan 'exec zsh' atau logout & login kembali untuk mengaktifkan Zsh."
