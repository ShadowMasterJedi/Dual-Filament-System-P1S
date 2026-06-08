# Dual Filament System – Delivery Summary & Memory Context

**Projektnavn**: Dual Filament Feeder System til Bambu P1S  
**Repo**: https://github.com/ShadowMasterJedi/Dual-Filament-System-P1S  
**Dato**: 8. juni 2026 (opdateret – komplet sensor wiring + config)  
**Status**: S6 flashet · Feedere kører · VREF kalibreret · Sensor wiring defineret – klar til fysisk montering  
**Sværhedsgrad**: Medium

---

## Projektmål

Fuldt autonomt dual-filament feeder system. Filamentskift sker 100% automatisk uden manuel indgriben.

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
| FYSETC S6 v2.1 + 2× TMC2209 v1.3  | Styring (E0+E1, standalone, VREF kalibreret)      | ✅ Flashet      |
| Raspberry Pi                       | Klipper + Fluidd/Mainsail + dashboard             | ✅ Kørende      |

---

## Repo-filer (seneste tilstand)

| Fil                            | Indhold                                      |
|-------------------------------|----------------------------------------------|
| `klipper/filament_sensor.cfg` | Alle 5 sensorer, pins, runout_gcode          |
| `klipper/macros_sensors.cfg`  | RUNOUT_A/B, SWITCH_TO_B, PRELOAD_B, STATUS   |
| `klipper/macros.cfg`          | _FEEDER_VARS, PURGE_NOZZLE, test-macros      |
| `klipper/printer.cfg`         | manual_stepper E0+E1, tmc2209 standalone     |
| `hardware/wiring_sensors.md`  | Komplet wiring guide med farver + test-cmds  |

---

## Klipper nøgleparametre

- **Board**: FYSETC S6 v2.1 (STM32F446, 32KiB bootloader, USB PA11/PA12)
- **Steppers**: `[manual_stepper feeder1]` E0 / `[manual_stepper feeder2]` E1
- **UART**: Standalone (accepteret produktionsvalg)
- **VREF**: E0 = 0.99V, E1 = 1.01V
- **Porte**: Moonraker :7126, Dashboard :8881, Mainsail :8082
- **Pi hostname**: linuxrobot

---

## Åbne punkter

- [ ] Fysisk montering af Sensor A og B ved hver spole
- [ ] Tilslut kabler til S6 (E2, Z+, X+, Y+, Z-)
- [ ] Test alle 5 sensorer med `SENSOR_STATUS`
- [ ] Mål PTFE-distancer → kalibrer `load_dist` / `retract_dist`
- [ ] Kalibrer `rotation_distance` på begge feedere
- [ ] Print Y-splitter + mounts
- [ ] Vælg notifikationskanal

---

## Session-noter

- **7. juni 2026**: Projekt oprettet, repo bygget, S6 flashet, UART standalone accepteret
- **8. juni 2026 (tidlig)**: To BTT SFS V2.0 per-spool sensorer tilføjet til arkitekturen
- **8. juni 2026 (sen)**: Komplet port-mapping defineret for alle 5 sensorer + config + wiring guide klar til GitHub push
