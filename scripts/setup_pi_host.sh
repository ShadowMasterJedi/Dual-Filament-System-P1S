#!/bin/bash
# Kør på Raspberry Pi efter første boot (MainsailOS)
# Deployer Dual Filament config til dedikeret Pi-host
set -euo pipefail

PROJECT="${HOME}/Dual-Filament-System-P1S"
CONFIG="${HOME}/printer_data/config"

echo "==> Kloner repo (hvis mangler)..."
if [ ! -d "${PROJECT}" ]; then
    git clone https://github.com/ShadowMasterJedi/Dual-Filament-System-P1S.git "${PROJECT}"
fi

echo "==> Deployer Klipper config..."
bash "${PROJECT}/scripts/install.sh"
