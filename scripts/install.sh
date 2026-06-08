#!/bin/bash
# Deploy Klipper config parallelt – overskriver IKKE printer.cfg (UR3)
set -euo pipefail

DEST="${HOME}/printer_data/config"
SRC="$(dirname "$0")/../klipper"

echo "Kopierer dual-filament config til ${DEST} (UR3 printer.cfg bevares)..."
cp "${SRC}/printer.cfg" "${DEST}/dual_filament_printer.cfg"
cp "${SRC}/macros.cfg" "${DEST}/dual_filament_macros.cfg"
cp "${SRC}/macros_sensors.cfg" "${DEST}/dual_filament_macros_sensors.cfg"
cp "${SRC}/filament_sensor.cfg" "${DEST}/dual_filament_filament_sensor.cfg"
cp "${SRC}/mainsail.cfg" "${DEST}/dual_filament_mainsail.cfg"

# Ret includes til parallelle filnavne
sed -i \
  -e 's|\[include mainsail.cfg\]|[include dual_filament_mainsail.cfg]|' \
  -e 's|\[include macros.cfg\]|[include dual_filament_macros.cfg]|' \
  -e 's|\[include macros_sensors.cfg\]|[include dual_filament_macros_sensors.cfg]|' \
  -e 's|\[include filament_sensor.cfg\]|[include dual_filament_filament_sensor.cfg]|' \
  "${DEST}/dual_filament_printer.cfg"

echo "Faerdig!"
echo "  dual_filament_printer.cfg"
echo "  dual_filament_macros.cfg"
echo "  dual_filament_macros_sensors.cfg"
echo "  dual_filament_filament_sensor.cfg"
echo ""
echo "Genstart dual-filament Klipper:"
echo "  systemctl --user restart klipper-dual-filament"
