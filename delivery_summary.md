# Dual Filament System – Delivery Summary & Memory Context

**Projektnavn**: Dual Filament Feeder System til Bambu P1S  
**Repo**: https://github.com/ShadowMasterJedi/Dual-Filament-System-P1S  
**Dato**: 11. juni 2026  
**Status**: S6 flashet · Pi3feeder Klipper ready · TMC2208 UART E0+E1 bekræftet  
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
| Feeder 1 – Redrex Dual Gear        | Aktiv feeder (Spool A) + pancake NEMA17          | ✅ Købt         |
| Feeder 2 – Redrex Dual Gear        | Standby feeder (Spool B) + pancake NEMA17          | ✅ Købt         |
| Sensor A (BTT SFS V2.0)            | Motion+runout ved Spool A – E2+Z+ porte           | ✅ Har          |
| Sensor B (BTT SFS V2.0)            | Motion+runout ved Spool B – X++Y+ porte           | ✅ Har          |
| Downstream BTT sensor              | Fail-safe efter Y-splitter – Z- port              | ✅ Har          |
| Y-Splitter 4-port (print)          | Passiv sammenføjning 2 feedere → P1S              | ✅ Printet      |
| NEMA17 pancake 24 mm aksel ×2      | Kompakte steppere til Redrex-extrudere              | ✅ Købt         |
| PC4-M6 bowden fitting              | 4 stk (2× Redrex + reserve)                       | ✅ Har          |
| PTFE 2,0 mm ID                     | 2× 300 mm (feeder → splitter)                       | ✅ Har          |
| FYSETC S6 v2.1 + 2× TMC2208 V2    | Styring E0+E1, UART, `run_current` 0.65 A         | ✅ Produktion   |
| Raspberry Pi 3 (`pi3feeder`)       | Klipper + MainsailOS host                         | ✅ Kørende      |

---

## Repo-filer (seneste tilstand)

| Fil                            | Indhold                                      |
|-------------------------------|----------------------------------------------|
| `klipper/printer.cfg`         | manual_stepper feeder1/2 + `[include tmc2208_uart.cfg]` |
| `klipper/tmc2208_uart.cfg`    | TMC2208 UART E0 (PA15) + E1 (PC5)            |
| `klipper/macros.cfg`          | MANUAL_STEPPER macros, PURGE, test           |
| `klipper/filament_sensor.cfg` | Downstream runout-sensor (produktion)        |
| `docs/tmc2208_uart_test.md`   | UART produktionsguide + fejlsøgning          |
| `docs/jumper_guide.md`        | PDN-EN på, 2×4 blok af                       |
| `hardware/wiring_sensors.md`  | Komplet wiring guide med farver + test-cmds  |

---

## Klipper nøgleparametre

- **Board**: FYSETC S6 v2.1 (STM32F446, 32KiB bootloader, USB PA11/PA12)
- **Steppers**: `[manual_stepper feeder1]` E0 / `[manual_stepper feeder2]` E1
- **Drivere**: BTT TMC2208 V2 ×2, UART via `[tmc2208]` sektioner
- **Jumpere**: PDN-EN **PÅ** per E0/E1; 2×4 blok **AF**
- **Strøm**: `run_current: 0.650` A (justeres i config / `SET_TMC_CURRENT`)
- **Pi hostname**: `pi3feeder` (192.168.50.14)
- **Mainsail**: `http://pi3feeder.local/` (port 7125)

---

## Åbne punkter

- [ ] Fysisk montering af Sensor A og B ved hver spole
- [ ] Tilslut kabler til S6 (E2, Z+, X+, Y+, Z-)
- [ ] Test alle 5 sensorer med `SENSOR_STATUS`
- [ ] Montér Redrex + pancake steppere på S6 E0/E1
- [ ] Tilslut PTFE: 2× feeder → Y-splitter (port 1+2) → udgang → P1S
- [ ] Mål PTFE-distancer → kalibrer `load_dist` / `retract_dist`
- [ ] Kalibrer `rotation_distance` på begge feedere (`TEST_FEEDER1/2`)
- [ ] Køb én længere PTFE (splitter → sensor → P1S) — se `docs/feeder_bom.md`
- [ ] Vælg notifikationskanal

---

## Session-noter

- **7. juni 2026**: Projekt oprettet, repo bygget, S6 flashet
- **8. juni 2026**: Sensor-arkitektur + config + wiring guide
- **9. juni 2026**: Pi 3 (`pi3feeder`) MainsailOS host kørende; NUC parallel dual-Klipper udfaset
- **10. juni 2026**: TMC2209 standalone (VREF 0,99/1,01 V); E2 UART-test med TMC2208 V2 — succes
- **11. juni 2026**: TMC2208 V2 monteret i E0+E1; UART produktion bekræftet fra Mainsail (`DUMP_TMC`, motor-test)
