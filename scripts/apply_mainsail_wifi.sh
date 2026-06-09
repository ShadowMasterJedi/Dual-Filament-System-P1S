#!/bin/bash
# Sæt WiFi på flashet MainsailOS v2+ (Bookworm, NetworkManager)
# Bruger headless_nm.txt på boot-partitionen – IKKE wpa_supplicant
set -euo pipefail

DEVICE="${DEVICE:-/dev/mmcblk0}"
BOOT_PART="${BOOT_PART:-${DEVICE}p1}"
MOUNT="/mnt/piboot"

WIFI_SSID="${WIFI_SSID:-Waoo4920_998N}"
WIFI_COUNTRY="${WIFI_COUNTRY:-DK}"
WIFI_HIDDEN="${WIFI_HIDDEN:-false}"

if [ "$(id -u)" -ne 0 ]; then
    echo "Kør med sudo:  sudo bash $0"
    exit 1
fi

if [ ! -b "${BOOT_PART}" ]; then
    echo "Boot-partition findes ikke: ${BOOT_PART}"
    echo "Sluk Pi'en, sæt SD-kort i NUC, og prøv igen."
    exit 1
fi

if [ -z "${WIFI_PASSWORD:-}" ]; then
    read -r -s -p "WiFi adgangskode (${WIFI_SSID}): " WIFI_PASSWORD
    echo ""
fi

mkdir -p "${MOUNT}"
umount "${MOUNT}" 2>/dev/null || true
mount "${BOOT_PART}" "${MOUNT}"

BOOT_DIR="${MOUNT}"
[ -d "${MOUNT}/firmware" ] && BOOT_DIR="${MOUNT}/firmware"

# Fjern gammel (forkert) firstrun fra tidligere script-version
rm -f "${BOOT_DIR}/firstrun.sh"
if [ -f "${BOOT_DIR}/cmdline.txt" ]; then
    sed -i 's| systemd.run.*||g' "${BOOT_DIR}/cmdline.txt"
fi

# MainsailOS Bookworm v2+ metode
cat > "${BOOT_DIR}/headless_nm.txt" <<EOF
SSID="${WIFI_SSID}"
PASSWORD="${WIFI_PASSWORD}"
HIDDEN="${WIFI_HIDDEN}"
REGDOMAIN="${WIFI_COUNTRY}"
EOF

sync
umount "${MOUNT}"

echo ""
echo "✅ WiFi sat på MainsailOS SD-kort (headless_nm.txt)"
echo "   SSID:     ${WIFI_SSID}"
echo "   Land:     ${WIFI_COUNTRY}"
echo ""
echo "Næste skridt:"
echo "  1. SD-kort i Pi 3 → strøm"
echo "  2. Vent 2-5 min (Pi forbinder automatisk)"
echo "  3. http://mainsailos.local  eller find IP på routeren"
echo ""
echo "Hostname er typisk: mainsailos.local (ikke pi3feeder)"
