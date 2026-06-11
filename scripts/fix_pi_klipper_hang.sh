#!/bin/bash
# Pi hænger efter boot — gendan config fra SD (Pi SLUKKET)
set -euo pipefail

DEVICE="${DEVICE:-/dev/mmcblk0}"
ROOT_PART="${ROOT_PART:-${DEVICE}p2}"
MOUNT="/mnt/piroot"
CFG="${MOUNT}/home/pi/printer_data/config/printer.cfg"
PROJECT="$(cd "$(dirname "$0")/.." && pwd)"

if [ "$(id -u)" -ne 0 ]; then
    echo "Kør med sudo:  sudo bash $0"
    exit 1
fi

if [ ! -b "${ROOT_PART}" ]; then
    echo "❌ SD ikke fundet: ${ROOT_PART}"
    echo "   Sluk Pi, sæt SD i NUC."
    lsblk
    exit 1
fi

echo "=== Pi recovery — gendan Klipper-config ==="
lsblk -o NAME,SIZE,LABEL "${DEVICE}"
echo ""

mkdir -p "${MOUNT}"
umount "${MOUNT}" 2>/dev/null || true
mount "${ROOT_PART}" "${MOUNT}"

if [ ! -f "${CFG}" ]; then
    echo "❌ printer.cfg ikke fundet på SD: ${CFG}"
    umount "${MOUNT}"
    exit 1
fi

cp "${CFG}" "${CFG}.bak.$(date +%Y%m%d%H%M)"

# Fjern E2-test include (forårsager ofte crash hvis driver ikke sidder i E2)
sed -i 's/^\[include tmc2208_uart_e2_test.cfg\]/#&/' "${CFG}"

# Gendan config fra repo
if [ "${RESTORE_REPO:-1}" = "1" ]; then
    cp "${PROJECT}/klipper/printer.cfg" "${CFG}"
    SERIAL=$(grep 'serial:' "${CFG}.bak."* 2>/dev/null | head -1 | awk '{print $2}' || true)
    if [ -n "${SERIAL}" ]; then
        sed -i "s|serial: .*|serial: ${SERIAL}|" "${CFG}"
    fi
    cp "${PROJECT}/klipper/macros.cfg" "${MOUNT}/home/pi/printer_data/config/macros.cfg"
    cp "${PROJECT}/klipper/filament_sensor.cfg" "${MOUNT}/home/pi/printer_data/config/filament_sensor.cfg"
    cp "${PROJECT}/klipper/tmc2208_uart.cfg" "${MOUNT}/home/pi/printer_data/config/tmc2208_uart.cfg"
fi

chown -R 1000:1000 "${MOUNT}/home/pi/printer_data/config/"*.cfg 2>/dev/null || true

echo ""
echo "printer.cfg (første 15 linjer):"
head -15 "${CFG}"
echo ""
echo "UART-linjer:"
grep -n tmc2208 "${CFG}" || echo "  (ingen aktive UART-includes)"

LOG="${MOUNT}/home/pi/printer_data/logs/klippy.log"
if [ -f "${LOG}" ]; then
    echo ""
    echo "Seneste Klipper-fejl:"
    grep -iE 'error|tmc2208|IFCNT|shutdown' "${LOG}" 2>/dev/null | tail -8 || true
fi

sync
umount "${MOUNT}"

echo ""
echo "✅ SD repareret"
echo "   1. SD i Pi 3 → strøm"
echo "   2. Vent 3–5 min — prøv ssh pi@pi3feeder.local"
echo "   3. Mainsail skal vise Ready (TMC2208 UART E0+E1)"
echo ""
echo "   Fejlsøgning: docs/tmc2208_uart_test.md"
