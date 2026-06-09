#!/bin/bash
# Nulstil pi-brugerens password via SD-kort (Pi slukket, kort i NUC)
set -euo pipefail

DEVICE="${DEVICE:-/dev/mmcblk0}"
ROOT_PART="${ROOT_PART:-${DEVICE}p2}"
BOOT_PART="${BOOT_PART:-${DEVICE}p1}"
CHROOT="/mnt/piroot"
NEW_PASSWORD="${PI_PASSWORD:-raspberry}"

if [ "$(id -u)" -ne 0 ]; then
    echo "Kør med sudo:  sudo PI_PASSWORD=nytpass bash $0"
    exit 1
fi

if [ ! -b "${ROOT_PART}" ]; then
    echo "Root-partition findes ikke: ${ROOT_PART}"
    echo "Sluk Pi'en, sæt SD-kort i NUC, og prøv igen."
    lsblk 2>/dev/null | grep -E 'mmc|sd' || true
    exit 1
fi

echo "=== Nulstiller password på ${ROOT_PART} ==="
lsblk -o NAME,SIZE,FSTYPE,LABEL "${DEVICE}"
echo "Nyt password for bruger 'pi': ${NEW_PASSWORD}"
echo ""

mkdir -p "${CHROOT}"
umount "${CHROOT}/boot/firmware" 2>/dev/null || true
umount "${CHROOT}" 2>/dev/null || true
mount "${ROOT_PART}" "${CHROOT}"
mkdir -p "${CHROOT}/boot/firmware"
mount "${BOOT_PART}" "${CHROOT}/boot/firmware"

mount --bind /dev "${CHROOT}/dev"
mount --bind /proc "${CHROOT}/proc"
mount --bind /sys "${CHROOT}/sys"
mount --bind /dev/pts "${CHROOT}/dev/pts"

chroot "${CHROOT}" bash -c "echo 'pi:${NEW_PASSWORD}' | chpasswd"

umount "${CHROOT}/dev/pts"
umount "${CHROOT}/dev" "${CHROOT}/proc" "${CHROOT}/sys"
umount "${CHROOT}/boot/firmware"
umount "${CHROOT}"
sync

echo ""
echo "✅ Password nulstillet til: ${NEW_PASSWORD}"
echo "   Sæt SD-kort i Pi → boot → ssh pi@pi3feeder.local"
