# FYSETC S6 v2.1 – Standalone (uden UART)

**Status (juni 2026):** Produktionsopsætning for Dual Filament feedere.  
BTT TMC2209 V1.3 UART kunne ikke etableres trods omfattende jumper-test — standalone virker stabilt.

---

## Config (Klipper)

`[tmc2209]`-sektionerne er **udkommenteret** i `klipper/printer.cfg`. Kun `[manual_stepper]` bruges:

| Feeder | Slot | step | dir | enable |
|--------|------|------|-----|--------|
| Feeder 1 | E0 | PD5 | PD6 | !PD4 |
| Feeder 2 | E1 | PE6 | !PC13 | !PE5 |

**Vigtigt:** Feeder 1 bruger `dir_pin: PD6` (ikke `!PD6`) — ellers brummer motoren uden at dreje.

Strøm styres via **VREF-potentiometer** på hver driver (~1,0–1,2 V for ~0,7–0,9 A).

---

## Jumpere (E0 + E1)

| Område | Standalone |
|--------|------------|
| PDN-EN | **AF** |
| 2×4 blok mellem headers | **AF** |
| UART1 / øvrige | **AF** |
| E2, Z, X, Y | **AF** |

Alle jumpere fjernet på E0/E1 er **korrekt** for standalone.

---

## Strømforsyning

| Forbindelse | Formål |
|-------------|--------|
| USB → Pi | Klipper-kommunikation |
| 24V → Main PWR | Motorstrøm (VMOT) |
| 5V-jumper | **5V + DC5V** (ikke USB5V+5V) når 24V er til |

---

## VREF-justering

1. Multimeter: sort på GND, rød på VREF-skruen på driveren
2. Start ~**1,0 V**, kør `TEST_FEEDER1` / `TEST_FEEDER2`
3. Øg langsomt hvis motor er svag; sænk hvis den bliver varm eller brummer

---

## Test

```
FIRMWARE_RESTART
TEST_FEEDER1
TEST_FEEDER2
```

Forventet: `ready`, ingen TMC/UART-fejl, begge motorer drejer.

---

## Hvad I mister vs UART

- Software `run_current` i config
- `DUMP_TMC` / driver-diagnostik
- Nem strømjustering per materiale uden at åbne boardet

Feeder-funktion, macros og sensor er **uændret**.

---

## UART senere (valgfrit)

Se `docs/jumper_guide.md`. Mulige veje:

- FYSETC TMC2209 V3.1 (plug-and-play på S6)
- Verificer BTT-driver underside: PDN → pin 4
- Genaktiver `[tmc2209]` med `uart_pin: PA15` (E0) og `PC5` (E1)
