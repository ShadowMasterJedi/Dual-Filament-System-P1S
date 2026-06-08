# FYSETC S6 v2.1 – Jumper-guide

**Opdateret:** 7. juni 2026

---

## Aktuel produktionsopsætning: STANDALONE

Dual Filament kører **uden UART**. Se **`standalone_guide.md`** for komplet opsætning.

**E0 + E1 (begge slots):**

| Jumper | Indstilling |
|--------|-------------|
| PDN-EN | **AF** |
| 2×4 blok / UART1 | **AF** |
| Alt andet | **AF** |

Config: `[tmc2209]` udkommenteret — strøm via **VREF** på driver.

---

## Reference: UART (fremtidig / fejlsøgning)

Følgende blev testet uden succes med BTT TMC2209 V1.3:

- PDN-EN på + række 1/2/3 i 2×4-blok
- Kun PDN-EN på
- Venstre/højre kolonne i pin-grid
- E2-slot test (`uart_pin: PE0`) — samme `IFCNT`-fejl

Konklusion: sandsynligt driver- eller UART-hardwareproblem — ikke løst med jumper alene.

### UART-jumpere (hvis I prøver igen)

Billeder og tegninger:

- `hardware/jumper-pdn-en-uart.jpg`
- `hardware/jumper-btt-drivers-e0-e1.jpg`
- `hardware/jumper-raekke3-guide.svg`
- `hardware/jumper-tegning-dit-board.svg`
- `hardware/jumper-overlay.html`
- `images/TMC2209.JPG` (officiel BTT vs S6 pin 4)

| Område | BTT TMC2209 UART |
|--------|------------------|
| PDN-EN (separat 2-pin) | **PÅ** |
| 2×4 blok mellem headers | BTT: **række 3** (over begge kolonner) — eller UART1 nederste række venstre kolonne |
| Række 1, 2, 4 | Tom |

FYSETC egne TMC2209 V3.1 kræver typisk **kun PDN-EN** — ingen ekstra JP6-jumper.

### UART config (når det virker)

```cfg
[tmc2209 manual_stepper feeder1]
uart_pin: PA15
run_current: 0.650
sense_resistor: 0.110

[tmc2209 manual_stepper feeder2]
uart_pin: PC5
run_current: 0.650
sense_resistor: 0.110
```

UART OK = ingen `Unable to read tmc uart register IFCNT` i loggen.

Officiel kilde: [FYSETC/FYSETC-S6](https://github.com/FYSETC/FYSETC-S6) · [Wiki](https://wiki.fysetc.com/FYSETC_S6/)
