# ABN6502 Rev. 2 procurement notes

The KiCad source is authoritative. `BOM-6502-reconciled.csv` was reconciled against `6502.kicad_sch`, `ram-vga.kicad_sch`, and `6502.kicad_pcb`; it replaces the JLC CSV only for procurement. The archived JLC BOM and CPL contain incorrect designator-to-part mappings and must not be submitted for assembly.

## Available from `../parts-is-parts`

| Board use | Catalog part | Available | Decision |
| --- | --- | ---: | --- |
| U2 CPU | SYU6502 | 2 | Direct match. Fit with the 6502 (not WDC65C02) jumper configuration. |
| U16 SRAM | AS6C62256-55PIN | 10 | Direct match for the 32K x 8, 28-pin 62256 position. |
| U19 counter | SN74LS161AN | 10 | Direct match for 74LS161. |
| 14-pin DIP sockets | D0814-42 | 30 | 5 required; sufficient. |
| 16-pin DIP sockets | D0816-42 | 36 | 6 required; sufficient. |
| 20-pin DIP sockets | 123-93-320-41-001000 | 5 | 3 required; sufficient. |
| 28-pin DIP sockets | 123-47-628-41-001000 | 8 | 2 required; sufficient. |
| 40-pin DIP sockets | 123-47-640-41-001000 | 9 | 2 required; sufficient. |

No 32-pin DIP socket is in the local catalog; obtain one for U5 if the flash is socketed.

## Do not substitute without validation

The catalog's 74LS00/04/14/32/74/245/273 parts share functions with several 74HC positions, but they are not approved replacements. A 74LS output's guaranteed logic-high level can be below a 74HC input's required high threshold at 5 V. Procure the specified 74HC parts unless the individual connection is reviewed and tested.

The ATS16B-E is a 16 MHz crystal but is not a documented fit for the board's Y2 3.2 x 2.5 mm SMD footprint. The AT28C256 and M27C128 are smaller than the required W27C512 image space, and are not drop-in ROM replacements.

## Configuration and programming

Firmware defaults to VRAM at `$0800`; configure the VGA address jumpers accordingly before first power-up. Program the SST39SF010 and W27C512 using the built images and verify their contents before fitting them. `./assemble.sh` now builds only; programming and RF deployment require explicit options.
