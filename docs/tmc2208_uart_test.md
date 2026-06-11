# TMC2208 V2 UART — Produktionsopsætning (FYSETC S6 v2.1)

**Status (juni 2026):** Dual Filament kører **UART med BTT TMC2208 V2** i E0+E1.  
**Tidligere:** BTT TMC2209 V1.3 fejlede UART (`Unable to read tmc uart register IFCNT`) — standalone med VREF var midlertidig løsning.

---

## Hardware

| Komponent | Slot | Status |
|-----------|------|--------|
| BTT TMC2208 V2 | E0 — Feeder 1 | ✅ Produktion |
| BTT TMC2208 V2 | E1 — Feeder 2 | ✅ Produktion |
| BTT TMC2209 V1.3 | — | ❌ Udfaset (UART virkede ikke) |

**Jumpere (E0 + E1):** Kun **PDN-EN PÅ** — 2×4-blok **AF** (samme som E2-testen).

Se også: `jumper_guide.md`, `hardware/jumper-overlay.html`

---

## Klipper-config

`klipper/printer.cfg`:

```cfg
[include tmc2208_uart.cfg]
```

`klipper/tmc2208_uart.cfg`:

```cfg
[tmc2208 manual_stepper feeder1]
uart_pin: PA15
run_current: 0.650
hold_current: 0.400
sense_resistor: 0.110
stealthchop_threshold: 999999

[tmc2208 manual_stepper feeder2]
uart_pin: PC5
run_current: 0.650
hold_current: 0.400
sense_resistor: 0.110
stealthchop_threshold: 999999
```

Strøm justeres i config eller live via Mainsail — **ikke VREF**.

---

## Test i Mainsail

```
FIRMWARE_RESTART
DUMP_TMC STEPPER=feeder1
DUMP_TMC STEPPER=feeder2
TEST_FEEDER1
TEST_FEEDER2
```

**UART OK:** Ingen `IFCNT`-fejl, `DUMP_TMC` viser registre (`pdn_disable=1`, `cs_actual=...`).

**Motor OK:** Stepper drejer ved `TEST_FEEDER1` / `TEST_FEEDER2`.

**Vigtigt:** Brug `STEPPER=feeder1` — **ikke** `STEPPER=manual_stepper feeder1`.

### Strømjustering (uden at åbne boardet)

```
SET_TMC_CURRENT STEPPER=feeder1 CURRENT=0.65
SET_TMC_CURRENT STEPPER=feeder2 CURRENT=0.65
```

---

## Fejlsøgning

| Problem | Handling |
|---------|----------|
| `IFCNT` / `Unable to read tmc2208` | Tjek PDN-EN på; prøv UART-pads på driver; test én slot ad gangen |
| Motor brummer uden rotation | Feeder 1 skal have `dir_pin: PD6` (ikke `!PD6`) |
| Motor svag | Øg `run_current` i config (start 0.65 A) |
| Pi hænger ved boot | `sudo bash scripts/fix_pi_klipper_hang.sh` (SD i NUC) |

---

## UART-pins (S6 v2.1)

| Feeder | Slot | `uart_pin` | STEP / DIR / EN |
|--------|------|------------|-----------------|
| Feeder 1 | E0 | `PA15` | PD5 / PD6 / !PD4 |
| Feeder 2 | E1 | `PC5` | PE6 / !PC13 / !PE5 |

---

## E2 enkelt-test (valgfri fejlsøgning)

Bruges kun til at isolere én driver — **ikke** produktion.

| E2 signal | S6 pin |
|-----------|--------|
| STEP | `PE2` |
| DIR | `!PE4` |
| ENABLE | `!PE3` |
| UART | `PE0` |

I `printer.cfg`: kommentér `tmc2208_uart.cfg` ud og aktivér `[include tmc2208_uart_e2_test.cfg]`.

Test:

```
DUMP_TMC STEPPER=e2_test
MOTOR_TEST_E2
```

---

## Arkiv: standalone (TMC2209)

Se `standalone_guide.md` — kun relevant som fallback hvis UART fejler med nye drivere.

---

## Referencer

- `docs/jumper_guide.md`
- `docs/calibration.md`
- [Klipper TMC2208](https://www.klipper3d.org/Config_Reference.html#tmc2208)
