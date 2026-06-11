#!/bin/bash
# Sæt hostname feedled + WiFi på flashet SD (Pi Zero) — kort i NUC, Pi slukket
# Kør EFTER flash_rpi_lite_pi3.sh
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
export PI_HOSTNAME=feedled
export WIFI_SSID="${WIFI_SSID:-Waoo4920_998N}"
export WIFI_PASSWORD="${WIFI_PASSWORD:?Sæt WIFI_PASSWORD}"
export PI_PASSWORD="${PI_PASSWORD:-raspberry}"
export DEVICE="${DEVICE:-/dev/mmcblk0}"

if [ "$(id -u)" -ne 0 ]; then
    echo "Kør med sudo:  sudo WIFI_PASSWORD='...' bash $0"
    exit 1
fi

exec bash "${DIR}/configure_pi_wifi.sh"
