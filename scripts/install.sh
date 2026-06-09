#!/bin/bash
# Deploy Klipper config til Raspberry Pi (MainsailOS)
# Kør på Pi:  bash scripts/install.sh
set -euo pipefail

PROJECT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="${HOME}/printer_data/config"
SRC="${PROJECT}/klipper"

echo "==> Kopierer config til ${CONFIG}..."
mkdir -p "${CONFIG}"
cp "${SRC}/printer.cfg" "${CONFIG}/printer.cfg"
cp "${SRC}/macros.cfg" "${CONFIG}/macros.cfg"
cp "${SRC}/filament_sensor.cfg" "${CONFIG}/filament_sensor.cfg"

echo "==> Opdater MCU serial (tilslut S6 via USB først)..."
SERIAL="$(ls /dev/serial/by-id/usb-Klipper_* 2>/dev/null | head -1 || true)"
if [ -n "${SERIAL}" ]; then
    sed -i "s|serial: .*|serial: ${SERIAL}|" "${CONFIG}/printer.cfg"
    echo "   MCU: ${SERIAL}"
else
    echo "   ⚠️  S6 ikke fundet – ret serial manuelt i printer.cfg"
fi

for f in printer.cfg macros.cfg filament_sensor.cfg; do
    [ -s "${CONFIG}/${f}" ] || { echo "❌ ${f} er tom!"; exit 1; }
done

echo "==> Genstarter Klipper..."
curl -sf -X POST "http://127.0.0.1:7125/printer/firmware_restart" >/dev/null \
    || sudo systemctl restart klipper

echo ""
echo "✅ Config deployet"
echo "   Mainsail:  http://$(hostname -I | awk '{print $1}')/"
