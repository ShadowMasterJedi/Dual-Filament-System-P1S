#!/bin/bash
# DEPRECATED – Dual Filament kører nu på Raspberry Pi, ikke på NUC
echo "❌ setup_mainsail.sh er udfaset."
echo ""
echo "Dual Filament hostes på Raspberry Pi (pi3feeder):"
echo "  1. Flash:     bash scripts/flash_pi_sd.sh"
echo "  2. WiFi:      bash scripts/apply_mainsail_wifi.sh"
echo "  3. Config:    bash scripts/setup_pi_host.sh  (på Pi)"
echo "     eller:     sudo bash scripts/deploy_pi_config_offline.sh  (SD i NUC)"
echo ""
echo "For at fjerne gammel NUC dual-Klipper stack:"
echo "  bash scripts/remove_nuc_dual_klipper.sh"
exit 1
