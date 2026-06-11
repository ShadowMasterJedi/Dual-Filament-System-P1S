#!/bin/bash
# Flash Pi OS Lite til Pi Zero (8 GB SD i NUC) + hostname feedled + WiFi
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
DEVICE="${DEVICE:-/dev/mmcblk0}"

export CONFIRM="${CONFIRM:-JA}"
export PI_HOSTNAME="${PI_HOSTNAME:-feedled}"
export WIFI_SSID="${WIFI_SSID:-Waoo4920_998N}"
export WIFI_PASSWORD="${WIFI_PASSWORD:?Sæt WIFI_PASSWORD}"
export PI_PASSWORD="${PI_PASSWORD:-raspberry}"
export DEVICE

if [ "$(id -u)" -ne 0 ]; then
    echo "Kør med sudo:  sudo WIFI_PASSWORD='...' bash $0"
    exit 1
fi

if [ ! -b "${DEVICE}" ]; then
    echo "❌ SD-kort ikke fundet: ${DEVICE}"
    echo "   Sæt 8 GB kort i NUC'ens indbyggede læser og prøv igen."
    lsblk 2>/dev/null || true
    exit 1
fi

echo "=== Pi Zero #1 — LED Bar host ==="
echo "    Hostname: ${PI_HOSTNAME}"
echo "    Device:   ${DEVICE}"
echo ""

bash "${DIR}/flash_rpi_lite_pi3.sh"

# cloud-init på boot-partition (Pi OS Trixie)
bash "${DIR}/configure_pi_wifi.sh"

echo ""
echo "✅ Pi Zero SD klar"
echo "   1. SD i Pi Zero → micro-USB strøm (data-port)"
echo "   2. Vent 3–5 min"
echo "   3. ssh pi@${PI_HOSTNAME}.local"
