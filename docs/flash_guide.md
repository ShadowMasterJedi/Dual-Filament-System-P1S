# Flash Guide – FYSETC S6 v2.1 med Klipper

## Forudsætninger
- Raspberry Pi 3 (`pi3feeder`) med MainsailOS
- SD-kort formateret som FAT32 (til S6 flash)
- USB-C kabel (S6 → Pi)

## Trin 1 – Byg firmware

```bash
cd ~/klipper
make menuconfig
```

Indstillinger:
```
Micro-controller:  STM32
Processor model:   STM32F446
Bootloader:        32KiB bootloader
Communication:     USB (on PA11/PA12)
```

```bash
make clean && make
```

## Trin 2 – Kopier til SD

```bash
cp ~/klipper/out/klipper.bin /media/pi/SD/firmware.bin
```

Filen **skal** hedde `firmware.bin`.

## Trin 3 – Flash

1. SD-kort i S6
2. USB-C til Pi
3. Tryk **RESET** på boardet
4. Vent 10 sek
5. `firmware.bin` → `firmware.CUR` = succes ✅

## Trin 4 – Find serial

```bash
ls /dev/serial/by-id/
# usb-Klipper_stm32f446_XXXXXXXXXXXX-if00
```

Indsæt stien i `klipper/printer.cfg` under `[mcu] serial:`.

## Trin 5 – Deploy config

**På Pi** (efter `git clone` af repo):

```bash
cd Dual-Filament-System-P1S
bash scripts/install.sh
```

**Eller offline fra NUC** (Pi slukket, SD i NUC-læser):

```bash
sudo bash scripts/deploy_pi_config_offline.sh
```

Genstart **ikke** Klipper manuelt hvis Pi lige er bootet — vent til Mainsail viser status.

Mainsail: `http://pi3feeder.local/`
