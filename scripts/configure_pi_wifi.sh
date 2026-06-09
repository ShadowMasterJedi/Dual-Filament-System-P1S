#!/bin/bash
# Konfigurer WiFi + SSH på flashet Raspberry Pi OS (Trixie cloud-init)
set -euo pipefail

DEVICE="${DEVICE:-/dev/mmcblk0}"
BOOT_PART="${BOOT_PART:-${DEVICE}p1}"
MOUNT="/mnt/piboot"
COUNTRY="${WIFI_COUNTRY:-DK}"
HOSTNAME="${PI_HOSTNAME:-pi3feeder}"
PI_USER="${PI_USER:-pi}"
PI_PASSWORD="${PI_PASSWORD:-}"

if [ "$(id -u)" -ne 0 ]; then
    echo "Kør med sudo:  sudo bash $0"
    exit 1
fi

if [ ! -b "${BOOT_PART}" ]; then
    echo "Boot-partition findes ikke: ${BOOT_PART}"
    lsblk "${DEVICE}" 2>/dev/null || true
    exit 1
fi

echo "=== SD-kort ==="
lsblk -o NAME,SIZE,FSTYPE,LABEL "${DEVICE}"
echo ""

if [ -z "${WIFI_SSID:-}" ]; then
    read -r -p "WiFi SSID: " WIFI_SSID
fi
if [ -z "${WIFI_PASSWORD:-}" ]; then
    read -r -s -p "WiFi adgangskode: " WIFI_PASSWORD
    echo ""
fi
if [ -z "${PI_PASSWORD}" ]; then
    read -r -s -p "Pi bruger '${PI_USER}' adgangskode [Enter = raspberry]: " PI_PASSWORD
    echo ""
    PI_PASSWORD="${PI_PASSWORD:-raspberry}"
fi

mkdir -p "${MOUNT}"
umount "${MOUNT}" 2>/dev/null || true
umount "${BOOT_PART}" 2>/dev/null || true
mount "${BOOT_PART}" "${MOUNT}"

# cloud-init kræver disse filer på boot-partitionen (Pi OS Trixie+)
cat > "${MOUNT}/network-config" <<EOF
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    eth0:
      dhcp4: true
      optional: true
  wifis:
    wlan0:
      dhcp4: true
      regulatory-domain: "${COUNTRY}"
      access-points:
        "${WIFI_SSID}":
          password: "${WIFI_PASSWORD}"
      optional: true
EOF

cat > "${MOUNT}/user-data" <<EOF
#cloud-config
hostname: ${HOSTNAME}
manage_etc_hosts: true
timezone: Europe/Copenhagen

users:
  - name: ${PI_USER}
    groups: users,adm,dialout,audio,netdev,video,plugdev,cdrom,games,input,gpio,spi,i2c,render,sudo
    shell: /bin/bash
    lock_passwd: false
    plain_text_password: ${PI_PASSWORD}
    sudo: ALL=(ALL) NOPASSWD:ALL

enable_ssh: true
ssh_pwauth: true
EOF

if [ ! -f "${MOUNT}/meta-data" ]; then
    cat > "${MOUNT}/meta-data" <<EOF
instance-id: ${HOSTNAME}
local-hostname: ${HOSTNAME}
EOF
fi

sync
umount "${MOUNT}"

echo ""
echo "✅ WiFi konfigureret på SD-kort"
echo "   SSID:     ${WIFI_SSID}"
echo "   Land:     ${COUNTRY}"
echo "   Hostname: ${HOSTNAME}"
echo "   SSH:      enabled"
echo "   Login:    ${PI_USER} / (dit valgte password)"
echo ""
echo "Næste skridt:"
echo "  1. SD-kort i Pi 3 → strøm"
echo "  2. Vent 2-5 min"
echo "  3. ssh ${PI_USER}@${HOSTNAME}.local"
echo "     eller find IP på routeren (ASUS RT-AX58U)"
