#!/bin/bash
# Fix "cannot open storage" i rpi-imager på NUC
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
    echo "Kør med sudo:  sudo bash $0"
    exit 1
fi

echo "==> Tilføjer bruger 'per' til disk-gruppen..."
usermod -aG disk per

echo "==> Frigør SD-kort..."
umount /dev/mmcblk0* 2>/dev/null || true
sync

echo "==> Test læseadgang..."
dd if=/dev/mmcblk0 of=/dev/null bs=512 count=1 status=none && echo "✅ SD-kort OK"

echo ""
echo "✅ Fix anvendt. Gør NU dette:"
echo "   1. Log ud og ind igen på NUC (eller kør: newgrp disk)"
echo "   2. Start Pi Imager:"
echo "      DISPLAY=:10.0 rpi-imager"
echo ""
echo "   ELLER kør Imager med sudo:"
echo "      sudo DISPLAY=:10.0 XAUTHORITY=/home/per/.Xauthority rpi-imager"
