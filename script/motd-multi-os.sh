#!/bin/bash

# Tambahkan PATH snap dan local
export PATH="/snap/bin:/usr/local/bin:$HOME/.local/bin:$PATH

# === DETEKSI OS ===
os_name="$(uname -s)"
distro="$(grep -E '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')"
arch="$(uname -m)"
is_rpi=false

# Deteksi Raspberry Pi dari hardware info
if grep -qi 'Raspberry Pi' /proc/cpuinfo 2>/dev/null; then
    is_rpi=true
fi

# Tentukan nama file logo sesuai OS
case "$os_name" in
    Darwin)
        logo_name="macos-logo.png"
        ;;
    Linux)
        if [ "$is_rpi" = true ]; then
            logo_name="raspberrypi-logo.png"
        elif [[ "$distro" == "ubuntu" ]]; then
            logo_name="ubuntu-logo.png"
        elif [[ "$distro" == "debian" ]]; then
            logo_name="debian-logo.png"
        else
            logo_name="linux-generic-logo.png"
        fi
        ;;
    *)
        logo_name="unknown-logo.png"
        ;;
esac
# Path lengkap logo
image_path="$HOME/.config/neofetch/$logo_name"

# === CETAK NEOFETCH TANPA ASCII ===
neofetch_output=$(neofetch --backend off)
output_lines=$(echo "$neofetch_output" | wc -l)
IFS=$'\n' read -rd '' -a output_array <<<"$neofetch_output"

for line in "${output_array[@]}"; do
    echo -e "$line"
done | lolcat

# === OFFSET KURSOR UNTUK GAMBAR ===
vertical_offset=$((output_lines - 2))
horizontal_offset=50

printf "\033[%dA" "$vertical_offset"
printf "\033[%dC" "$horizontal_offset"

# === TAMPILKAN GAMBAR JIKA MUNGKIN ===
if [[ -f "$image_path" ]]; then
    if command -v imgcat &>/dev/null; then
        imgcat "$image_path"
    elif command -v /usr/local/bin/imgcat &>/dev/null; then
        /usr/local/bin/imgcat "$image_path"
    elif command -v viu &>/dev/null; then
        viu -w 40 -h 20 "$image_path"
    elif command -v chafa &>/dev/null; then
        chafa "$image_path"
    else
        echo "[imgcat/viu/chafa tidak tersedia]" >&2
    fi
else
    echo "[Logo '$logo_name' tidak ditemukan di $image_path]" >&2
fi

# === INFO TAMBAHAN ===
echo "" | lolcat
echo "System Uptime   : $(uptime -p)" | lolcat
echo "Today's Date    : $(date)" | lolcat
last_login=$(last -n 1 | head -n 1)
echo "Last User Login : $last_login" | lolcat
remote_ip=$(who | grep "$(whoami)" | awk '{print $5}' | tr -d '()')
[ -z "$remote_ip" ] && remote_ip="Local Session"
echo "Remote IP       : $remote_ip" | lolcat