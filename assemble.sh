#!/usr/bin/env bash
# Build only.  Programming and RF deployment are explicit opt-in actions.
set -euo pipefail

mkdir -p build
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
msbasic_root="${MSBASIC_ROOT:-$script_dir/../../dotpoly/msbasic}"

if [[ ! -f "$msbasic_root/msbasic.s" ]]; then
  echo "Microsoft BASIC is enabled but msbasic.s was not found at: $msbasic_root" >&2
  echo "Set MSBASIC_ROOT to the msbasic checkout, or disable BASIC in abn6502rom.s." >&2
  exit 1
fi

ca65 -vvv --cpu 6502 -I "$(dirname -- "$msbasic_root")" -l build/listing.txt -o build/abn6502rom.o abn6502rom.s
ca65 crom.s -o build/crom.o
ca65 userland.s --cpu 65c02 -l build/userlisting.txt -o build/userland.o
ld65 -o build/abn6502rom.bin -C memmap.cfg build/abn6502rom.o build/crom.o build/userland.o

case "${1:-build}" in
  build) ;;
  --program-sst39sf010)
    command -v firestarter >/dev/null || { echo "firestarter is required to program the SST39SF010" >&2; exit 1; }
    firestarter write sst39sf010 build/abn6502rom.bin
    ;;
  --deploy-rf)
    : "${ABN6502_RF_HOST:?Set ABN6502_RF_HOST to the RF bootloader host.}"
    ssh "$ABN6502_RF_HOST" killall bootload
    scp build/userland.bin "$ABN6502_RF_HOST:./"
    ssh "$ABN6502_RF_HOST" bootload -s userland.bin
    ssh "$ABN6502_RF_HOST" killall bootload
    ;;
  *)
    echo "Usage: $0 [build|--program-sst39sf010|--deploy-rf]" >&2
    exit 2
    ;;
esac
