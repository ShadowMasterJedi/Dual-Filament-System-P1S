#!/bin/bash
# Flash Raspberry Pi OS Lite (32-bit armhf) til Pi 3
set -euo pipefail

IMAGE="/home/per/Downloads/raspios-lite/2026-04-21-raspios-trixie-armhf-lite.img.xz"
DEVICE="${DEVICE:-/dev/mmcblk0}"
NEED_BYTES=$((3000 * 1024 * 1024))   # ~3 GiB uudpakket

if [ "$(id -u)" -ne 0 ]; then
    echo "Kør med sudo:  sudo bash $0"
    exit 1
fi

# NUC indbygget læser: kræver SDHCI-quirks (se scripts/fix_nuc_sd_reader.sh)
if [ "${DEVICE}" = "/dev/mmcblk0" ] && [ "$(cat /sys/module/sdhci/parameters/debug_quirks2 2>/dev/null || echo 0)" = "0" ]; then
    echo "⚠️  NUC SD-læser fix ikke aktiv!"
    echo "   Kør først:  sudo bash $(dirname "$0")/fix_nuc_sd_reader.sh"
    echo ""
    read -r -p "Fortsæt alligevel? (j/N): " risky
    [ "${risky,,}" = "j" ] || exit 1
fi

if [ ! -f "${IMAGE}" ]; then
    echo "Mangler image: ${IMAGE}"
    echo "Download først fra Raspberry Pi Imager eller:"
    echo "  wget -P ~/Downloads/raspios-lite \\"
    echo "    https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2026-04-21/2026-04-21-raspios-trixie-armhf-lite.img.xz"
    exit 1
fi

if [ ! -b "${DEVICE}" ]; then
    echo "Enhed findes ikke: ${DEVICE}"
    echo "Sæt SD-kort i læseren (eller sæt DEVICE=/dev/sdX for USB-læser)."
    exit 1
fi

CARD_BYTES=$(blockdev --getsize64 "${DEVICE}")
CARD_GIB=$(awk "BEGIN {printf \"%.1f\", ${CARD_BYTES}/1024/1024/1024}")

echo "=== SD-kort ==="
lsblk -o NAME,SIZE,TYPE,MODEL,TRAN "${DEVICE}"
echo ""
echo "Image:  Raspberry Pi OS Lite (32-bit, Pi 3)"
echo "Kort:   ${CARD_GIB} GiB"
echo "Kræver: ~3 GiB"
echo ""

if [ "${CARD_BYTES}" -lt "${NEED_BYTES}" ]; then
    echo "❌ SD-kortet er for lille!"
    exit 1
fi

if [ "${CONFIRM:-}" != "JA" ]; then
    read -r -p "Flash ${DEVICE}? Skriv JA: " confirm
    [ "${confirm}" = "JA" ] || { echo "Afbryder."; exit 1; }
fi

if [ -f "${IMAGE}.sha256" ]; then
    echo "Verificerer checksum..."
    cd "$(dirname "${IMAGE}")"
    sha256sum -c "$(basename "${IMAGE}").sha256"
fi

umount "${DEVICE}"* 2>/dev/null || true
sync

echo ""
echo "Flasher Raspberry Pi OS Lite... (ca. 5-10 min)"
xzcat "${IMAGE}" | dd of="${DEVICE}" bs=4M status=progress conv=fsync
sync

partprobe "${DEVICE}" 2>/dev/null || true
sleep 2
lsblk "${DEVICE}"
echo ""
echo "✅ Flash færdig!"
echo ""
echo "Næste skridt:"
echo "  1. SD-kort i Pi 3 → micro-USB strøm (2.5A+)"
echo "  2. Ethernet til router eller WiFi via rpi-imager ⚙️"
echo "  3. SSH: ssh pi@raspberrypi.local  (standard login: pi / raspberry — skift password!)"
