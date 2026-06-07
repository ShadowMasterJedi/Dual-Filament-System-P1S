# Dual Filament System – Delivery Summary & Memory Context

**Projektnavn**: Dual Filament Feeder System til Bambu P1S  
**Repo**: https://github.com/ShadowMasterJedi/Dual-Filament-System-P1S  
**Dato**: 7. juni 2026 (opdateret)  
**Status**: S6 flashet · Klipper kører · UI deployeret – klar til mekanik & kalibrering  
**Sværhedsgrad**: Medium (Mekanik + Klipper opsætning)

---

## Projektmål

Bygge et automatisk dual-filament feeder system med to uafhængige steppere, Y-splitter, BTT sensor og Klipper-styring, så filamentskift sker semi-automatisk med minimal manuel indgriben.

---

## Arbejdsgang (defineret)

1. Indlæs filament fra **Spool A** → Feeder 1 → Y-splitter → BTT Sensor → P1S
2. **Preload Spool B** via Feeder 2 op til Y-splitteren (standby)
3. Start print på P1S (Feeder 1 assisterer aktivt)
4. **Runout** trigges på BTT-sensor
5. **Klipper-macro** pauser print, aktiverer Feeder 2 (feed igennem Y-splitter → sensor → P1S)
6. Macro kører **automatisk purge-sekvens** (retract → skift → prime → purge tower/wipe)
7. Print **genoptages automatisk** – ingen manuel indgriben
8. **Notifikation** sendes som info (ikke som krav om handling)

> ⚠️ **Design-krav**: Systemet skal være fuldt autonomt. Ingen manuel load eller purge på P1S.

---

## Hvad er leveret (7. juni 2026)

### Firmware & Klipper

| Leverance | Status |
|-----------|--------|
| Klipper firmware til FYSETC S6 v2.1 (STM32F446, 32KiB bootloader) | ✅ Bygget & flashet |
| `scripts/build_firmware.sh` + `scripts/fysetc_s6_v21.config` | ✅ |
| Parallel Klipper-instans (`klipper-dual-filament.service`) | ✅ UR3 urørt |
| `dual_filament_*.cfg` deployet til `~/printer_data/config/` | ✅ |

**MCU serial** (S6 board):
```
/dev/serial/by-id/usb-Klipper_stm32f446xx_410061000751333134383631-if00
```

Flash udført via **DFU** (`dfu-util`, adresse `0x08008000`). SD-kort-metode dokumenteret i `docs/flash_guide.md`.

### Web-UI & Mainsail

| UI | URL | Formål |
|----|-----|--------|
| Operator dashboard | `http://<pi-ip>:8881/` | Hurtig styring, status, macros |
| Mainsail (S6) | `http://<pi-ip>:8082/` | Fuld Klipper-UI til loader |
| UR3 + printervælger | `http://<pi-ip>/` | Vælg *Dual Filament S6* i menu |

Deploy: `bash scripts/setup_mainsail.sh`

**Services** (systemd user):
- `klipper-dual-filament` – S6 Klipper
- `moonraker-dual-filament` – API port **7126**
- `feeder-dashboard` – dashboard port **8881**
- `feeder-mainsail` – Mainsail port **8082**

UR3/Octopus-setup (`printer.cfg`, `ur3clone_*.cfg`) er **bevaret parallelt** og overskrives ikke.

### Macros (dashboard + Mainsail)

| Macro | Formål |
|-------|--------|
| `PRELOAD_B` | Preload Spool B til Y-splitter |
| `FILAMENT_RUNOUT` | Autonomt filamentskift |
| `SIMULATE_RUNOUT` | Test runout-sekvens |
| `TEST_FEEDER1` / `TEST_FEEDER2` | Test 50 mm feed |
| `FEEDER1_JOG` / `FEEDER2_JOG` | Jog frem (default 10 mm) |
| `RETRACT_FEEDER1` / `RETRACT_FEEDER2` | Retract |
| `SYSTEM_STATUS` | Status i konsol |
| `EMERGENCY_STOP_FEEDERS` | Nødstop (M84) |

Kalibreringsvariabler i `_FEEDER_VARS`: retract 100 mm, load 350 mm, purge 50 mm.

---

## Komponentstatus

| Komponent | Rolle | Status |
|-----------|-------|--------|
| Feeder 1 + Stepper 1 | Aktiv feeder (E0) | ✅ Har – TMC UART mangler montering |
| Feeder 2 + Stepper 2 | Standby/preload (E1) | ✅ Har – TMC UART mangler montering |
| BTT Filament Sensor | Runout efter Y-splitter (PB10) | ✅ Har – skal testes |
| FYSETC S6 v2.1 + 2× TMC2209 | Stepper-styring | ✅ Flashet & forbundet |
| Raspberry Pi | Klipper + Moonraker + Mainsail | ✅ Kører (linuxrobot) |
| Y-Splitter (PTFE) | Passiv sammenføjning | 🖨️ Skal printes |

---

## BOM – Mangler

| Vare | Antal | Note |
|------|-------|------|
| PTFE Tubing Capricorn 1.75mm | 4–5 m | Lav friktion anbefales |
| PC4-M6 / PC4-M10 fittings | 10 stk | Push-to-connect |
| Filament Feeder (BMG/Orbiter) | 2 stk | Hobbed gear + bearings |
| Dual Spool Holder | 1 stk | Printes eller købes |
| Y-Splitter + mounts | 1 sæt | 3D-printes |
| 24V PSU (5–10A ekstra) | 1 stk | Anbefales til stepper-test |

**Estimeret ekstraomkostning**: 450–850 DKK

---

## Faser & Status

### Fase 1 – Hardware & Print
- [ ] Print Y-splitter, feeder mounts, spool holder
- [ ] Bestil manglende komponenter (PTFE, fittings, feedere)
- [ ] Saml mekanik og monter feedere

### Fase 2 – Klipper Opsætning
- [x] Klipper + Moonraker + Mainsail på Pi
- [x] FYSETC S6 v2.1 flashet med Klipper-firmware
- [x] 2× TMC2209 defineret i `printer.cfg` (E0/E1)
- [x] `manual_stepper feeder1` + `feeder2` konfigureret
- [x] Parallel instans – UR3 bevaret

### Fase 3 – Kalibrering
- [ ] Monter TMC2209 i E0/E1 med UART-jumper (JP1)
- [ ] Kalibrer `rotation_distance` på Feeder 1
- [ ] Kalibrer `rotation_distance` på Feeder 2
- [ ] Test PTFE-routing og Y-splitter flow

### Fase 4 – Sensor & Macros
- [x] BTT Filament Sensor i `filament_sensor.cfg`
- [x] `FILAMENT_RUNOUT` macro skrevet
- [x] `PRELOAD_B` macro skrevet
- [ ] Test sensor + macros med rigtig filament
- [ ] Opsæt notifikationer (Discord/Telegram)

### Fase 5 – Test & Finjustering
- [ ] End-to-end test med runout-simulation (fysisk)
- [ ] Juster burst-længde og timing i `_FEEDER_VARS`
- [ ] Integration med P1S print-flow

---

## Mappestruktur (udvidet)

```
Dual-Filament-System-P1S/
├── klipper/
│   ├── printer.cfg              # S6 hoved-config
│   ├── macros.cfg               # Feeder-macros + dashboard
│   ├── filament_sensor.cfg      # BTT sensor PB10
│   └── mainsail.cfg             # Minimal Mainsail-support
├── config/
│   └── moonraker.conf           # Moonraker port 7126
├── web/
│   ├── dashboard.html           # Operator dashboard
│   ├── dashboard.css
│   └── dashboard.js
├── deploy/
│   ├── feeder-dashboard.service
│   ├── feeder-mainsail.service
│   └── moonraker-dual-filament.service
├── scripts/
│   ├── install.sh               # Parallel config-deploy
│   ├── setup_mainsail.sh        # Fuld UI-opsætning
│   ├── build_firmware.sh
│   └── fysetc_s6_v21.config
├── firmware/                    # (gitignored) klipper.bin
├── docs/
│   ├── flash_guide.md
│   └── calibration.md
└── delivery_summary.md          # Denne fil
```

---

## Åbne Spørgsmål / Beslutninger

- [x] Har bruger Raspberry Pi allerede? **JA**
- [x] System skal køre **fuldt autonomt** – ingen manuel load/purge på P1S
- [x] Klipper config-eksempler copy-paste klar? **JA – i repo**
- [x] UR3-setup skal bevares parallelt? **JA – implementeret**
- [ ] Foretrukket notifikationskanal (Discord / Telegram / email)?
- [ ] Præcis PTFE-distance fra Y-splitter til P1S extruder? (til `load_dist`)
- [ ] Har P1S AMS eller kører den stock single-feed?

---

## Kendte begrænsninger

1. **TMC UART** – Klipper viser `Unable to read tmc uart` indtil drivere er monteret med JP1-jumper.
2. **PURGE_NOZZLE** – Purge af P1S hotend sker ikke direkte (ingen extruder på S6); macro feeder kun ekstra filament.
3. **Port 81** – Kræver root på Linux; dashboard bruger **8881** i stedet.
4. **P1S integration** – Runout/pause/resume skal kobles til P1S-print (endnu ikke testet fysisk).

---

## Session-noter (7. juni 2026)

- Projekt klonet og S6 flashet via DFU på `linuxrobot` (192.168.50.119)
- UR3 `printer.cfg` + symlinks bevaret; dual-filament kører som separat systemd-instans
- Moonraker på port 7126, dashboard 8881, dedikeret Mainsail 8082
- Hoved-Mainsail (port 80) har printervælger: *UR3 Octopus* + *Dual Filament S6*

**Genstart alt:**
```bash
bash ~/Projects/Dual-Filament-System-P1S/scripts/setup_mainsail.sh
```

---

## Noter til Fremtidige Sessions

- Board er **FYSETC S6 v2.1** (STM32F446) – **ikke** BTT SKR Pro/Octopus
- Feeder 1 = **E0-slot**, Feeder 2 = **E1-slot** – se `hardware/wiring_notes.md`
- Y-splitter er **passiv** – ingen aktiv selector i V1
- `_FEEDER_VARS.load_dist` (350 mm) er udgangspunkt – skal måles og kalibreres
- Mulig V2: 3. stepper som aktiv selector

---

*Opdateret efter flash, parallel Klipper-opsætning og dashboard/Mainsail-deploy.*
