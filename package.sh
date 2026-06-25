#!/usr/bin/env bash

# Use Cadius to create a disk image for distribution
# https://github.com/mach-kernel/cadius

set -e

IMGFILE="out/martymations.po"
VOLNAME="MARTYMATIONS"

rm -f "$IMGFILE"
cadius CREATEVOLUME "$IMGFILE" "$VOLNAME" 140KB --no-case-bits --quiet > /dev/null

PACKDIR=$(mktemp -d)
trap "rm -r $PACKDIR" EXIT

add_file () {
    cp "$1" "$PACKDIR/$2"
    cadius ADDFILE "$IMGFILE" "/$VOLNAME" "$PACKDIR/$2" --no-case-bits --quiet > /dev/null
}

add_file "res/PRODOS" "PRODOS#FF0000"
add_file "res/BASIC.SYSTEM" "BASIC.SYSTEM#FF0000"
add_file "res/PLAY.BAS" "STARTUP#FC0801"
add_file "out/demolib.bin" "DEMOLIB#068000"
for pic in $(seq 1 6); do
    add_file "res/PIC${pic}A.BIN" "PIC${pic}A#064000"
    add_file "res/PIC${pic}B.BIN" "PIC${pic}B#066000"
done

