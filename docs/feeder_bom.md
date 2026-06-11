# Feeder BOM – Redrex Dual Gear + Pancake NEMA17

**Valgt setup (juni 2026):** 2× færdige Redrex-extrudere + 2× pancake steppere.  
Tidligere plan (HANOV-print + POLISI gears) er erstattet — se [Alternativ](#alternativ-hanov--polisi) nederst.

## Valgt extruder

| | |
|---|---|
| **Produkt** | Redrex Dual Gear Extruder (Ender 3 / CR-10 kompatibel) |
| **Antal** | **2 stk** (Feeder 1 + Feeder 2) |
| **Type** | Dual drive (BMG-stil), 1,75 mm |
| **Status** | ✅ Købt |

### Hvorfor Redrex

- Komplet extruder — ingen separat gear-sæt eller printet hus nødvendigt
- Dual drive giver godt greb til feeder/preload (ikke hotend-ekstrudering)
- Standard NEMA17 5 mm aksel — passer til de fleste pancake-motorer
- Billig og udbredt på Amazon/Ali

---

## Valgt stepper

| | |
|---|---|
| **Produkt** | NEMA17 pancake stepper |
| **Aksellængde** | 24 mm |
| **Antal** | **2 stk** |
| **Status** | ✅ Købt |

### Pancake – vigtige noter

| Emne | Anbefaling |
|------|------------|
| **Moment** | Pancake har mindre moment end fuld-højde NEMA17 — OK til bowden-feeder, ikke til direkte hotend |
| **Strøm** | `run_current: 0.65` A via TMC2208 UART — juster i `tmc2208_uart.cfg` hvis der slippes |
| **Montering** | Tjek at D-fladen på akslen sidder korrekt i Redrex-klemmen før stramning |
| **rotation_distance** | Skal kalibreres per feeder — startværdi `7.710` i `printer.cfg` er kun estimat |

---

## Y-splitter (printet)

| | |
|---|---|
| **Model** | Egen print — **4 indgange** |
| **Antal** | 1 stk |
| **Status** | ✅ Printet |

### Anbefalet port-layout (2-feeder → P1S)

```
[Feeder 1] ──PTFE──► Indgang 1 ─┐
                                 ├── [4-port Y] ──► Udgang (til sensor + P1S)
[Feeder 2] ──PTFE──► Indgang 2 ─┘
                     Indgang 3–4: PLUG / reserve
```

| Port | Funktion |
|------|----------|
| **1** | Bowden fra Feeder 1 (Spool A) |
| **2** | Bowden fra Feeder 2 (Spool B) |
| **3** | Udgang → downstream BTT-sensor → P1S AMS-inlet |
| **4** | Tilstop med plug (eller reserve til service/purge-line) |

> Kun **én** feeder skal aktivt skubbe filament ad gangen. Den anden skal være retraced bag Y-punktet (se `retract_dist` i macros).

---

## Allerede på lager

| Komponent | Antal | Status |
|-----------|-------|--------|
| Redrex Dual Gear extruder | 2 | ✅ Købt |
| NEMA17 pancake (24 mm aksel) | 2 | ✅ Købt |
| Y-splitter 4-port (print) | 1 | ✅ Printet |
| PC4-M6 bowden fitting | 4 | ✅ Har |
| PTFE bowden 2,0 mm ID | 2× 300 mm | ✅ Har |
| FYSETC S6 E0/E1 slots | 2 | ✅ Har |
| BTT TMC2208 V2 (UART, E0+E1) | 2 | ✅ Monteret |
| BTT filament sensorer | 3+ | ✅ Har |
| Raspberry Pi 3 (`pi3feeder`) | 1 | ✅ Kørende |

### PTFE-budget (300 mm × 2)

| Stykke | Længde | Status |
|--------|--------|--------|
| Redrex Feeder 1 → Y-splitter port 1 | 300 mm | ✅ Dækket |
| Redrex Feeder 2 → Y-splitter port 2 | 300 mm | ✅ Dækket |
| Y-splitter udgang → downstream sensor → P1S | **mangler** | 🛒 Køb 0,5–1,5 m |

> 300 mm er fint til **feeder → splitter** (korte stræk). Du skal stadig have én **længere** PTFE fra splitter-udgang til sensor og videre til P1S — typisk 500–1500 mm afhængigt af opsætning.

### PC4-M6-budget (4 stk)

| Placering | Antal | Status |
|-----------|-------|--------|
| I hver Redrex (bowden-udgang) | 2 | ✅ Dækket |
| Reserve / sensor- eller P1S-ende | 2 | ✅ Har — brug ved behov |
| Ubrugte splitter-porte (3–4) | — | PTFE-plug eller foldet tape — ikke PC4-M6 |

---

## Resten af indkøbslisten

| # | Komponent | Antal | Est. pris | Status |
|---|-----------|-------|-----------|--------|
| 1 | PTFE splitter → sensor → P1S (2,0 mm ID) | 0,5–1,5 m | ~€5–10 | 🛒 Køb |
| 2 | PTFE-plug til ubrugt splitter-port | 1–2 | ~€2 | 🛒 Valgfrit |
| 3 | Ekstra PC4-M6 (sensor/P1S-ende) | 0–2 | ~€3 | 🛒 Valgfrit |
| 4 | M3 skruer til motor/extruder-montering | 1 sæt | ~€3 | 🛒 Køb |
| 5 | Kabelclips / bowden-holder ved feedere | — | — | 🖨️ Valgfrit print |

**Estimeret rest**: ca. 50–100 DKK (primært én længere PTFE-streng)

---

## Montering

1. Montér pancake NEMA17 på hver Redrex (5 mm aksel, D-flade mod set screw)
2. Tilslut motor til S6 **E0-MOT** (Feeder 1) og **E1-MOT** (Feeder 2)
3. Sæt **PC4-M6** i hver Redrex; montér **300 mm PTFE** til Y-splitter port 1 og 2
4. Én **længere PTFE** fra splitter-udgang → downstream sensor → P1S (egen længde — mål før køb)
5. Tilstop ubrugte splitter-porte
6. Kør `TEST_FEEDER1` / `TEST_FEEDER2` i Mainsail — se [`calibration.md`](calibration.md)
7. Mål PTFE-længder → opdater `_FEEDER_VARS` (`retract_dist`, `load_dist`)

### Strøm (TMC2208 UART)

- PDN-EN jumper **PÅ** på begge E0/E1-drivere
- Strøm i `klipper/tmc2208_uart.cfg` (`run_current: 0.650`) — juster i Mainsail med `SET_TMC_CURRENT`
- Se `docs/tmc2208_uart_test.md` og `docs/calibration.md`

---

## Alternativ: HANOV + POLISI (ikke valgt)

Tidligere plan var selvprintet [HANOV BMG-hus](https://www.printables.com/model/308550) + [POLISI gear kit B07L23XRQT](https://www.amazon.de/dp/B07L23XRQT).  
Beholdes som reference hvis en feeder skal repareres med reservedele.
