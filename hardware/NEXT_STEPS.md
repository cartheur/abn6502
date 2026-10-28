# ABN6502 hardware next steps

Do not manufacture `hardware/jlcpcb/production_files/GERBER-6502.zip` again until this list is completed. It contains a confirmed mechanical collision.

## Blocker: H3 collides with U3/R6522

`H3` is a 4.3 mm plated M4 mounting hole at `X=119.225923 mm`, `Y=117.574923 mm`. It falls within the body area of `U3`, the horizontal 40-pin R6522 DIP footprint. The hole sits between the pin rows, so it does not necessarily produce an electrical DRC error, but it prevents fitting a normal DIP package or socket.

The collision is present in both the KiCad PCB and the archived Gerber set. Do not use the current Gerbers for a new order.

## KiCad repair workflow

1. Open `hardware/6502.kicad_pro` in the KiCad Flatpak (`org.kicad.KiCad`):

   ```sh
   flatpak run org.kicad.KiCad hardware/6502.kicad_pro
   ```
2. In PCB Editor, inspect U3 and H3 in the lower-left portion of the board.
3. Decide whether H3 is required. Prefer removing it if the other three mounting holes provide sufficient mechanical support; otherwise relocate it outside all component courtyards, connector bodies, and edge-clearance constraints.
4. Keep U3's 40-pin DIP socket/package courtyard clear, including room to insert and remove the chip.
5. Refill copper zones, run DRC, and resolve all errors. Review mechanical/courtyard warnings manually; the original collision may not be caught electrically.
6. Inspect front and back fabrication/3D views before release.

## Release checklist after repair

- Generate a new Gerber and drill archive from the repaired PCB.
- Confirm the archive's `Edge.Cuts`, PTH, NPTH, copper, mask, and both silk layers are present.
- Replace the archived production Gerber only after visual review in the fabricator preview.
- Regenerate the assembly BOM/CPL from the repaired PCB. Do not reuse the historical JLC BOM/CPL: their designator-to-part mappings are known to disagree with the current schematic.
- Compare the generated BOM with `BOM-6502-reconciled.csv` and `PROCUREMENT.md`.
- Record the new Gerber generation date, KiCad version, and a preview screenshot in the commit message or release note.

## Firmware build baseline

The firmware builds with the local CC65 toolchain at `../../dotpoly/cc65/bin` and Microsoft BASIC at `../../dotpoly/msbasic` (or an explicit `MSBASIC_ROOT`). Hardware fixes should not alter this build, but run `./assemble.sh` after any related source changes.
