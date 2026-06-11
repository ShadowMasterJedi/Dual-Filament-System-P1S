# FYSETC S6 v2.1 – Standalone (uden UART) — ARKIV

> **Udfaset juni 2026.** Produktion kører nu **TMC2208 V2 UART** — se `tmc2208_uart_test.md` og `jumper_guide.md`.  
> Behold denne guide kun som fallback hvis UART fejler, eller hvis I midlertidigt skifter tilbage til TMC2209 uden UART.

---

## Historik

BTT TMC2209 V1.3 UART kunne ikke etableres trods omfattende jumper-test (`IFCNT`-fejl). Standalone med VREF var stabil midlertidig løsning indtil **BTT TMC2208 V2** blev testet og bekræftet på E0+E1.

---

## Config (standalone)

Fjern/kommentér `[include tmc2208_uart.cfg]` i `printer.cfg`. Kun `[manual_stepper]` bruges:

| Feeder | Slot | step | dir | enable |
|--------|------|------|-----|--------|
| Feeder 1 | E0 | PD5 | PD6 | !PD4 |
| Feeder 2 | E1 | PE6 | !PC13 | !PE5 |

**Vigtigt:** Feeder 1 bruger `dir_pin: PD6` (ikke `!PD6`) — ellers brummer motoren uden at dreje.

Strøm styres via **VREF-potentiometer** på hver driver (~1,0–1,2 V for ~0,7–0,9 A).

---

## Jumpere (E0 + E1) — standalone

| Område | Standalone |
|--------|------------|
| PDN-EN | **AF** |
| 2×4 blok mellem headers | **AF** |
| UART1 / øvrige | **AF** |

---

## VREF-justering (TMC2209 standalone)

Måles **direkte på TMC-modulet**:

| Probe | Hvor |
|-------|------|
| Rød | Midten af potentiometer-skruen |
| Sort | GND-pin på modulets pin-header |

**Tidligere kalibreret (juni 2026):**

| Driver | Slot | VREF |
|--------|------|------|
| E0 | Feeder 1 | **0,99 V** |
| E1 | Feeder 2 | **1,01 V** |

---

## Test

```
FIRMWARE_RESTART
TEST_FEEDER1
TEST_FEEDER2
```

---

## Tilbage til UART (anbefalet)

1. Montér **BTT TMC2208 V2** i E0+E1
2. **PDN-EN PÅ** per slot
3. Aktivér `[include tmc2208_uart.cfg]` i `printer.cfg`
4. `FIRMWARE_RESTART` → `DUMP_TMC STEPPER=feeder1`
