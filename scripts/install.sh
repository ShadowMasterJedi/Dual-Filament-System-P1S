#!/bin/bash
# Deploy Klipper config-filer til printer_data/config

DEST="${HOME}/printer_data/config"
SRC="$(dirname "$0")/../klipper"

echo "Kopierer config-filer til ${DEST}..."
cp "${SRC}/printer.cfg" "${DEST}/"
cp "${SRC}/macros.cfg" "${DEST}/"
cp "${SRC}/filament_sensor.cfg" "${DEST}/"
echo "Faerdig! Genstart Klipper i Fluidd/Mainsail."
