# ========================= PATH dan Variabel Lingkungan =========================
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/local/share/myenv/bin:$PATH
export PATH="$HOME/Library/Python/3.13/bin:$PATH"
export PATH="$HOME/.local/share/nvim/lazy-rocks/bin:$PATH"
export PYTHONPATH=/opt/homebrew/lib/python3.9/site-packages:$PYTHONPATH
export XDG_CONFIG_HOME="$HOME/.config"

# ========================= Konfigurasi ZSH & Oh My Zsh =========================
export ZSH="$HOME/.oh-my-zsh"
export ZSH_DISABLE_COMPFIX=true
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Tema dan Plugin Oh My Zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search zsh-you-should-use zsh-bat)

source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ========================= Konfigurasi MacOS =========================
#source ~/.iterm2_shell_integration.zsh
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH="/opt/homebrew/opt/libtool/libexec/gnubin:$PATH"
export PATH="$PATH:/Applications/OpenVPN Connect/OpenVPN Connect.app/contents/MacOS/"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="/opt/homebrew/opt/node@20/bin:$PATH"
export ARCHFLAGS="-arch $(uname -m)"

#alias opvn="OpenVPN Connect" ## membuka aplikasi OpenVPN Connect

# ========================= Alias untuk MacOS =========================
#alias showroute="netstat -nr -f inet" ## untuk melihat routing table
#alias rsdock="defaults write com.apple.dock ResetLaunchPad -bool true && killall Dock" ## reset Launchpad di Mac
#alias dnsflush="sudo killall -HUP mDNSResponder" ## flush DNS cache
#alias sshcpid='ssh-copy-id -i ~/.ssh/MyID-MacMini.pub -p 22' ## menyalin SSH public key
#alias cpwd='pwd | tr -d "\n" | pbcopy' ## menyalin path direktori saat ini
#alias caff="caffeinate -ism" ## mencegah Mac masuk ke mode tidur
#alias cl="fc -e -|pbcopy" ## menyalin output perintah terakhir
#alias cleanDS="find . -type f -name '*.DS_Store' -ls -delete" ## menghapus file .DS_Store
#alias showHidden='defaults write com.apple.finder AppleShowAllFiles TRUE' ## menampilkan file tersembunyi
#alias hideHidden='defaults write com.apple.finder AppleShowAllFiles FALSE' ## menyembunyikan file tersembunyi
#alias capc="screencapture -c" ## menangkap layar ke clipboard
#alias capic="screencapture -i -c" ## menangkap layar secara interaktif ke clipboard
#alias capiwc="screencapture -i -w -c" ## menangkap layar interaktif dengan window
alias myip='curl ifconfig.me' ## menampilkan IP publik
#alias mylocalip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}'" ## menampilkan IP lokal
#alias volup="osascript -e 'set volume output volume ((output volume of (get volume settings)) + 10)'" ## meningkatkan volume sebanyak 10%
#alias voldown="osascript -e 'set volume output volume ((output volume of (get volume settings)) - 10)'" ## menurunkan volume sebanyak 10%
#alias mute="osascript -e 'set volume output muted true'" ## menonaktifkan suara
#alias unmute="osascript -e 'set volume output muted false'" ## mengaktifkan suara kembali
#alias restartfinder="killall Finder" ## me-restart Finder
#alias restartdock="killall Dock" ## me-restart Dock
#alias flushcache="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder" ## membersihkan cache DNS dan memperbarui konfigurasi jaringan
#alias listservices="launchctl list" ## menampilkan daftar layanan yang berjalan di macOS
#alias backupdock="defaults export com.apple.dock ~/Desktop/dock-backup.plist" ## menyimpan pengaturan Dock sebelum restart
#alias restoredock="defaults import com.apple.dock ~/Desktop/dock-backup.plist; killall Dock" ## mengembalikan pengaturan Dock setelah restart
#alias runningapps="ps aux | grep -v grep | grep -i" ## melihat proses aplikasi yang berjalan
#alias killapp="pkill -f" ## menutup aplikasi secara paksa
#alias sysinfo="top -o cpu" ## menampilkan proses dengan penggunaan CPU tertinggi
#alias wifi-status="networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print \$NF}' | xargs -I{} networksetup -getairportpower {}" ## melihat status Wi-Fi dengan mendeteksi antarmuka yang benar
#alias wifi-on="networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print \$NF}' | xargs -I{} networksetup -setairportpower {} on" ## mengaktifkan Wi-Fi secara otomatis di antarmuka yang benar
#alias wifi-off="networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print \$NF}' | xargs -I{} networksetup -setairportpower {} off" ## menonaktifkan Wi-Fi secara otomatis di antarmuka yang benar
alias openhere="open ." ## membuka folder saat ini di Finder
alias folder-size="du -sh *" ## menampilkan ukuran folder secara ringkas
#alias cleanup="rm -rf ~/Library/Caches/* && sudo purge" ## membersihkan file sementara dan cache

# ========================= Konfigurasi eza (Pengganti ls) =========================
if command -v eza &> /dev/null; then
  alias ls="eza $eza_params --icons --group-directories-first"
  alias ll="eza --icons --group-directories-first -AolhM"
  alias lt="eza --icons -AiolbM --tree --level=2"
  alias lg="eza --icons -lbGF --git"
  alias la="eza -lbhHgUmuSao --group-directories-first --icons"
else
  alias ls="ls" ## kembali ke default ls jika eza tidak ditemukan
fi

# ========================= Konfigurasi bat (Pengganti cat) =========================
[[ "$(command -v bat)" ]] && alias cat="bat"
export BAT_THEME="Dracula"
export BAT_STYLE="snip"
alias cat-l="cat --style=numbers"

# ========================= Syntax Highlighting dan Warna =========================
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh


# ========================= Preferensi Editor =========================
if command -v nvim &> /dev/null; then
  export EDITOR='nvim' ## Gunakan nvim jika tersedia
elif command -v code &> /dev/null; then
  export EDITOR='code -w' ## Gunakan VS Code jika tersedia
else
  export EDITOR='nano' ## Gunakan nano jika tidak ada yang lain
fi

# ========================= Alias Umum =========================
alias reload="source ~/.zshrc" ## memuat ulang konfigurasi zsh
alias clr="clear" ## membersihkan terminal
alias quit='exit' ## keluar dari terminal

# ========================= Alias Rekomendasi Tambahan =========================
alias grep='grep --color=auto' ## menampilkan hasil grep dengan warna
alias diff='diff --color=auto' ## menampilkan perbedaan dengan warna
alias du='du -h' ## menampilkan ukuran direktori dalam format yang mudah dibaca
alias df='df -h' ## menampilkan penggunaan disk dalam format yang mudah dibaca
alias h='history' ## menampilkan riwayat perintah
alias j='jobs' ## menampilkan daftar pekerjaan yang berjalan di background
alias path='echo -e ${PATH//:/\n}' ## menampilkan PATH dalam format yang lebih rapi
alias ports='netstat -tulanp' ## menampilkan daftar port yang digunakan
alias weather='curl wttr.in' ## menampilkan cuaca saat ini
alias update='brew update && brew upgrade' ## memperbarui paket Homebrew
alias cls='clear' ## membersihkan layar terminal
alias now='date +"%T"' ## menampilkan waktu saat ini
alias today='date +"%A, %B %d, %Y"' ## menampilkan tanggal saat ini

# ========================= Bantuan untuk Alias =========================
function alias-help() {
  echo -e "\e[1;34mDaftar Alias yang Tersedia:\e[0m"
  alias | sed 's/=.*##/ -->/' | while read -r line; do
    printf "\e[1;32m%s\e[0m\n" "$line"
  done
}
alias alias-help="alias-help" ## menampilkan daftar alias yang tersedia dengan deskripsi dalam warna hijau

