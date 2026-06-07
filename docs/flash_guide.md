# Flash Guide – FYSETC S6 v2.1 med Klipper

## Forudsætninger
- Raspberry Pi med Klipper (installer via KIAUH)
- SD-kort formateret som FAT32
- USB-C kabel

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

```bash
cd scripts && bash install.sh
```

Genstart Klipper i Fluidd/Mainsail.
