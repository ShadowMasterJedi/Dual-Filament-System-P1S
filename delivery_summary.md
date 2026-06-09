# Dual Filament System – Delivery Summary & Memory Context

**Projektnavn**: Dual Filament Feeder System til Bambu P1S  
**Repo**: https://github.com/ShadowMasterJedi/Dual-Filament-System-P1S  
**Dato**: 9. juni 2026 (Pi-host kørende – NUC dual-stack udfaset)  
**Status**: S6 flashet · Pi3feeder Klipper ready · Feedere konfigureret  
**Sværhedsgrad**: Medium

---

## Projektmål

Fuldt autonomt dual-filament feeder system. Filamentskift sker 100% automatisk uden manuel indgriben.

---

## Host-topologi

| Maskine | Rolle | Klipper | UI |
|---------|-------|---------|-----|
| **Raspberry Pi 3** (`pi3feeder`, 192.168.50.14) | Dual Filament host | Moonraker :7125 | `http://pi3feeder.local/` |
| **NUC** (`linuxrobot`, 192.168.50.119) | UR3 Octopus + SD-flash station | Moonraker :7125 (UR3) | `http://192.168.50.119/` |

S6 board USB-tilsluttet **Pi'en**, ikke NUC'en.

---

## Sensor-arkitektur

```
[Spool A] → [Sensor A (BTT SFS V2.0)] → [Feeder 1] ─┐
                                                        ├─ [Y-Splitter] → [Sensor DS (BTT)] → [P1S]
[Spool B] → [Sensor B (BTT SFS V2.0)] → [Feeder 2] ─┘
```

## Port-mapping – FYSETC S6 v2.1

| Signal           | Sensor     | S6 Port    | Klipper Pin |
|------------------|------------|------------|-------------|
| Switch (runout)  | Sensor A   | E2 endstop | `^PC15`     |
| Motion (encoder) | Sensor A   | Z+ endstop | `^PA0`      |
| Switch (runout)  | Sensor B   | X+ endstop | `^PC14`     |
| Motion (encoder) | Sensor B   | Y+ endstop | `^PA1`      |
| Switch (runout)  | Downstream | Z- endstop | `^PB12`     |

---

## Hardware-komponenter

| Komponent                          | Rolle                                             | Status         |
|------------------------------------|---------------------------------------------------|----------------|
| Feeder 1 + Stepper 1               | Aktiv feeder (Spool A)                            | ✅ Har          |
| Feeder 2 + Stepper 2               | Standby feeder (Spool B)                          | ✅ Har          |
| Sensor A (BTT SFS V2.0)            | Motion+runout ved Spool A – E2+Z+ porte           | ✅ Har          |
| Sensor B (BTT SFS V2.0)            | Motion+runout ved Spool B – X++Y+ porte           | ✅ Har          |
| Downstream BTT sensor              | Fail-safe efter Y-splitter – Z- port              | ✅ Har          |
| Y-Splitter (PTFE)                  | Passiv sammenføjning                              | 🖨️ Skal printes |
| HANOV BMG-hus ×2 (print)           | Selvprintet feeder-chassis                        | 🖨️ Skal printes |
| POLISI gear kit B07L23XRQT ×2      | BMG dual-drive gears (1,75 mm / 5 mm aksel)      | 🛒 Køb          |
| FYSETC S6 v2.1 + 2× TMC2209 v1.3  | Styring (E0+E1, standalone, VREF kalibreret)      | ✅ Flashet      |
| Raspberry Pi 3 (`pi3feeder`)       | Klipper + MainsailOS host                         | ✅ Kørende      |

---

## Repo-filer (seneste tilstand)

| Fil                            | Indhold                                      |
|-------------------------------|----------------------------------------------|
| `klipper/filament_sensor.cfg` | Downstream runout-sensor (produktion)        |
| `klipper/macros_sensors.cfg`  | RUNOUT_A/B, SWITCH_TO_B (fremtidig 5-sensor) |
| `klipper/macros.cfg`          | MANUAL_STEPPER macros, PURGE, test           |
| `klipper/printer.cfg`         | manual_stepper feeder1/2, MCU serial         |
| `hardware/wiring_sensors.md`  | Komplet wiring guide med farver + test-cmds  |

---

## Klipper nøgleparametre

- **Board**: FYSETC S6 v2.1 (STM32F446, 32KiB bootloader, USB PA11/PA12)
- **Steppers**: `[manual_stepper feeder1]` E0 / `[manual_stepper feeder2]` E1
- **UART**: Standalone (accepteret produktionsvalg)
- **VREF**: E0 = 0.99V, E1 = 1.01V
- **Pi hostname**: `pi3feeder` (192.168.50.14)
- **Mainsail**: `http://pi3feeder.local/` (port 7125)

---

## Åbne punkter

- [ ] Fysisk montering af Sensor A og B ved hver spole
- [ ] Tilslut kabler til S6 (E2, Z+, X+, Y+, Z-)
- [ ] Test alle 5 sensorer med `SENSOR_STATUS`
- [ ] Mål PTFE-distancer → kalibrer `load_dist` / `retract_dist`
- [ ] Kalibrer `rotation_distance` på begge feedere
- [ ] Print Y-splitter + mounts
- [ ] Print 2× HANOV BMG-hus
- [ ] Køb 2× POLISI gear kit (B07L23XRQT) — se `docs/feeder_bom.md`
- [ ] Montér feedere + kalibrer rotation_distance
- [ ] Vælg notifikationskanal

---

## Session-noter

- **7. juni 2026**: Projekt oprettet, repo bygget, S6 flashet, UART standalone accepteret
- **8. juni 2026**: Sensor-arkitektur + config + wiring guide
- **9. juni 2026**: Pi 3 (`pi3feeder`) MainsailOS host kørende; NUC parallel dual-Klipper udfaset; offline SD-deploy som sikker config-metode
