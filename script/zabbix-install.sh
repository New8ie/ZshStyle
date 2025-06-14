#!/bin/bash

# =======================
# Auto Install Zabbix Agent 2
# Supported OS: Debian/Ubuntu/Raspbian/macOS
# Author: Fachmi (Enhanced by ChatGPT)
# =======================

set -euo pipefail
IFS=$'\n\t'

ZBX_SERVERS="192.168.49.2,192.168.64.3"
ZBX_HOSTNAME="Zabbix.Homelabs"
ZBX_PORT="10050"

# ---------- Utilities ----------
log_info() { echo -e "\033[1;32m[INFO]\033[0m $*"; }
log_warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
log_error() { echo -e "\033[1;31m[ERROR]\033[0m $*"; }

remove_broken_mongodb_repo() {
  local broken_files
  broken_files=$(grep -rlE "mongodb-org/(7\.0|8\.0)" /etc/apt/sources.list.d/ 2>/dev/null || true)
  if [[ -n "$broken_files" ]]; then
    log_warn "Removing invalid MongoDB repository entries..."
    for file in $broken_files; do
      sudo rm -f "$file"
      log_info "Removed: $file"
    done
  fi
}

is_latest_zabbix_version() {
  if ! dpkg -s zabbix-agent2 &>/dev/null; then
    return 1
  fi
  local installed_version latest_version
  installed_version=$(dpkg-query -W -f='${Version}' zabbix-agent2)
  sudo apt-get update -qq >/dev/null
  latest_version=$(apt-cache policy zabbix-agent2 | awk '/Candidate:/ { print $2 }')
  if [[ "$installed_version" == "$latest_version" ]]; then
    log_info "Zabbix Agent2 already installed: version $installed_version (latest)"
    return 0
  else
    log_warn "Installed version: $installed_version | Latest: $latest_version"
    return 1
  fi
}

configure_zabbix_agent2() {
  local conf="/etc/zabbix/zabbix_agent2.conf"
  sudo sed -i "s|^Server=.*|Server=${ZBX_SERVERS}|" "$conf"
  sudo sed -i "s|^ServerActive=.*|ServerActive=${ZBX_SERVERS}|" "$conf"
  sudo sed -i "s|^Hostname=.*|Hostname=${ZBX_HOSTNAME}|" "$conf"
  sudo sed -i "s|^# ListenPort=.*|ListenPort=${ZBX_PORT}|" "$conf"
  log_info "Applied config:"
  grep -E "Server=|ServerActive=|Hostname=|ListenPort=" "$conf"
}

install_debian_family() {
  local os="$1"
  local url=""
  case "$os" in
    debian) url="https://repo.zabbix.com/zabbix/7.2/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.2+debian12_all.deb" ;;
    ubuntu) url="https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.2+ubuntu24.04_all.deb" ;;
    raspbian) url="https://repo.zabbix.com/zabbix/7.2/release/raspbian/pool/main/z/zabbix-release/zabbix-release_latest_7.2+debian12_all.deb" ;;
    *) log_error "Unsupported Debian family OS: $os"; exit 1 ;;
  esac

  log_info "Downloading and installing Zabbix repo for $os..."
  tmpdeb="/tmp/zabbix-release.deb"
  wget -qO "$tmpdeb" "$url"
  sudo dpkg -i "$tmpdeb"
  sudo apt-get update -qq
  sudo apt-get install -y zabbix-agent2

  configure_zabbix_agent2
  sudo systemctl restart zabbix-agent2
  sudo systemctl enable zabbix-agent2
}

install_macos() {
  if ! command -v brew &>/dev/null; then
    log_error "Homebrew not installed. Please install Homebrew first."
    exit 1
  fi

  if brew list --versions zabbix-agent2 &>/dev/null; then
    log_info "Zabbix Agent2 already installed on macOS:"
    brew list --versions zabbix-agent2
    log_info "Checking for upgrade..."
    brew upgrade zabbix-agent2 || true
  else
    brew install zabbix-agent2
  fi

  local conf="/opt/homebrew/etc/zabbix/zabbix_agent2.conf"
  mkdir -p "$(dirname "$conf")"

  cat > "$conf" <<EOF
Server=${ZBX_SERVERS}
ServerActive=${ZBX_SERVERS}
Hostname=${ZBX_HOSTNAME}
ListenPort=${ZBX_PORT}
LogType=console
EOF

  log_info "Starting Zabbix Agent2 on macOS..."
  pkill zabbix_agent2 || true
  nohup /opt/homebrew/sbin/zabbix_agent2 -c "$conf" > /tmp/zabbix_agent2.log 2>&1 &
  log_info "Zabbix Agent2 started in background (log: /tmp/zabbix_agent2.log)"
}

main() {
  log_info "Checking OS..."
  if [[ "$(uname)" == "Darwin" ]]; then
    install_macos
    return
  fi

  if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    remove_broken_mongodb_repo

    case "$ID" in
      debian|ubuntu|raspbian)
        if is_latest_zabbix_version; then
          exit 0
        else
          install_debian_family "$ID"
        fi
        ;;
      *)
        log_error "Unsupported OS: $ID"
        exit 1
        ;;
    esac
  else
    log_error "/etc/os-release not found. Cannot detect OS."
    exit 1
  fi

  log_info "Zabbix Agent2 installation complete."
}

main
