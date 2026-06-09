#!/bin/bash
# Flash MainsailOS til SD-kort (mmcblk0 eller angivet DEVICE)
set -euo pipefail

# Pi 3 → armhf (32-bit). Pi 4/5 → arm64.
ARCH="${ARCH:-arm64}"
case "${ARCH}" in
    armhf|pi3|32)
        IMAGE="/home/per/Downloads/mainsailos/2025-10-03-MainsailOS-raspberry_pi-armhf-bookworm-2.2.2.img.xz"
        NEED_BYTES=$((8600 * 1024 * 1024))
        ;;
    *)
        IMAGE="/home/per/Downloads/mainsailos/2025-10-03-MainsailOS-raspberry_pi-arm64-bookworm-2.2.2.img.xz"
        NEED_BYTES=$((8600 * 1024 * 1024))
        ;;
esac
DEVICE="${DEVICE:-/dev/mmcblk0}"

if [ "$(id -u)" -ne 0 ]; then
    echo "Kør med sudo:  sudo bash $0"
    exit 1
fi

if [ ! -f "${IMAGE}" ]; then
    echo "Mangler image: ${IMAGE}"
    exit 1
fi

if [ ! -b "${DEVICE}" ]; then
    echo "Enhed findes ikke: ${DEVICE}"
    echo "Sæt SD-kort i læseren og prøv igen."
    exit 1
fi

CARD_BYTES=$(blockdev --getsize64 "${DEVICE}")
CARD_GIB=$(awk "BEGIN {printf \"%.1f\", ${CARD_BYTES}/1024/1024/1024}")

echo "=== SD-kort ==="
lsblk -o NAME,SIZE,TYPE,MODEL,TRAN "${DEVICE}"
echo ""
echo "Kort kapacitet: ${CARD_GIB} GiB"
echo "Image kræver:   ~8.6 GiB uudpakket"
echo ""

if [ "${CARD_BYTES}" -lt "${NEED_BYTES}" ]; then
    echo "❌ SD-kortet er for lille til MainsailOS!"
    echo "   Brug mindst et 16 GB kort (I havde et 32 GB kort i NUC'en tidligere)."
    exit 1
fi

if [ "${CONFIRM:-}" != "JA" ]; then
    read -r -p "Flash ${DEVICE} (${CARD_GIB} GiB)? Skriv JA: " confirm
    [ "${confirm}" = "JA" ] || { echo "Afbryder."; exit 1; }
fi

echo "Verificerer image checksum..."
cd "$(dirname "${IMAGE}")"
sha256sum -c "$(basename "${IMAGE}").sha256"

umount "${DEVICE}"* 2>/dev/null || true
sync

echo ""
echo "Flasher MainsailOS... (10-20 min)"
xzcat "${IMAGE}" | dd of="${DEVICE}" bs=4M status=progress conv=fsync
sync

echo ""
echo "Verificerer partitioner..."
partprobe "${DEVICE}" 2>/dev/null || true
sleep 2
lsblk "${DEVICE}"
echo ""
echo "✅ Flash færdig!"
echo ""
echo "Næste skridt:"
echo "  1. SD-kort i Pi → USB-C strøm (Pi 4: 3A+, Pi 5: 27W anbefales)"
echo "  2. Ethernet til router ELLER WiFi sat op via rpi-imager"
echo "  3. http://mainsailos.local  (efter 2-5 min boot)"
