#!/bin/bash
# Skriv Klipper-config direkte på SD-kort (Pi SLUKKET, kort i NUC)
# Sikrere end Moonraker-upload når Pi hænger
set -euo pipefail

DEVICE="${DEVICE:-/dev/mmcblk0}"
ROOT_PART="${ROOT_PART:-${DEVICE}p2}"
MOUNT="/mnt/piroot"
CONFIG="${MOUNT}/home/pi/printer_data/config"
SERIAL="${MCU_SERIAL:-/dev/serial/by-id/usb-Klipper_stm32f446xx_410061000751333134383631-if00}"
PROJECT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${PROJECT}/klipper"

if [ "$(id -u)" -ne 0 ]; then
    echo "Kør med sudo:  sudo bash $0"
    exit 1
fi

if [ ! -b "${ROOT_PART}" ]; then
    echo "Root-partition findes ikke: ${ROOT_PART}"
    echo "Sluk Pi'en, sæt SD-kort i NUC, og prøv igen."
    exit 1
fi

echo "=== SD-kort ==="
lsblk -o NAME,SIZE,FSTYPE,LABEL "${DEVICE}"
echo ""

mkdir -p "${MOUNT}"
umount "${MOUNT}" 2>/dev/null || true
mount "${ROOT_PART}" "${MOUNT}"
mkdir -p "${CONFIG}"

cp "${SRC}/printer.cfg" "${CONFIG}/printer.cfg"
cp "${SRC}/macros.cfg" "${CONFIG}/macros.cfg"
cp "${SRC}/filament_sensor.cfg" "${CONFIG}/filament_sensor.cfg"
cp "${SRC}/tmc2208_uart.cfg" "${CONFIG}/tmc2208_uart.cfg"
sed -i "s|serial: .*|serial: ${SERIAL}|" "${CONFIG}/printer.cfg"
rm -f "${CONFIG}/macros_sensors.cfg"

# Kun rigtige filer – ikke symlinks (mainsail.cfg, timelapse.cfg)
for f in printer.cfg macros.cfg filament_sensor.cfg tmc2208_uart.cfg; do
    chown 1000:1000 "${CONFIG}/${f}"
    chmod 644 "${CONFIG}/${f}"
done

echo "Skrevet:"
ls -la "${CONFIG}/printer.cfg" "${CONFIG}/macros.cfg" "${CONFIG}/filament_sensor.cfg" "${CONFIG}/tmc2208_uart.cfg"

sync
umount "${MOUNT}"

echo ""
echo "✅ Config skrevet på SD-kort"
echo "   1. SD-kort i Pi 3 → strøm"
echo "   2. Vent 3-5 min – RØR IKKE restart-knapper i Mainsail endnu"
echo "   3. http://pi3feeder.local"
