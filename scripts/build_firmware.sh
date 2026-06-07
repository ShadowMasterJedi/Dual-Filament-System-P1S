#!/bin/bash
# Byg Klipper firmware til FYSETC S6 v2.1 (STM32F446, 32KiB bootloader)
set -euo pipefail

KLIPPER="${KLIPPER_DIR:-$HOME/klipper}"
OUT="${1:-$(dirname "$0")/../firmware}"

if [[ ! -d "$KLIPPER" ]]; then
    echo "Fejl: Klipper ikke fundet i $KLIPPER"
    echo "Klon med: git clone https://github.com/Klipper3d/klipper.git"
    exit 1
fi

CONFIG_FILE="$(dirname "$0")/fysetc_s6_v21.config"

echo "==> Konfigurerer Klipper for FYSETC S6 v2.1..."
cp "$CONFIG_FILE" "$KLIPPER/.config"
cd "$KLIPPER"
make olddefconfig

echo "==> Bygger firmware..."
make clean
make -j"$(nproc)"

mkdir -p "$OUT"
cp out/klipper.bin "$OUT/firmware.bin"
echo ""
echo "Firmware klar: $OUT/firmware.bin"
echo "Kopier til SD-kort som 'firmware.bin' og flash boardet (se docs/flash_guide.md)"
