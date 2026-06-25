# Martymations

Reverse-engineering of the Apple II animations by Martin Kahn.

## What are "Martymations"?

As noted on [Paleotronic](https://paleotronic.com/2019/04/24/martymations-hidden-apple-ii-art/):

> Hidden on the back side of the [Print Shop Color Apple II](https://archive.org/details/wozaday_The_Print_Shop_Color) disk is a series of dynamic artworks by Print Shop developer Martin Kahn. They are quite something, considering the extremely primitive nature of the Apple II’s high-resolution graphics mode.

Specifically, they are six distinct moving images powered by specific code that does a form of [color cycling](https://en.wikipedia.org/wiki/Color_cycling) animation.

## How do they work?

The disk is a modified DOS 3.3 image, as noted in [this Usenet post](https://csiph.com/group/comp.sys.apple2/t/80a64fe5-b5ed-45d7-a407-e96da362b606@googlegroups.com#a-24083). Digging in reveals six pairs of files (`PIC1A`, `PIC1B`, `PIC2A`, `PIC2B`, etc), a binary library called `DEMOLIB`, and a driver program in Applesoft BASIC.

To run one of the animations, the driver program does the following:

* Loads `PICnA` to $4000 (`BLOAD PICnA,A$4000`)
* Loads `PICnB` to $6000 (`BLOAD PICnB,A$6000`)
* Loads `DEMOLIB` at $8000 (`BLOAD DEMOLIB,A$8000`)
* Calls an initialization routine at $8500 (`CALL 34048`)
* Then loops
  * Sets $8507 to $80 (`POKE 34055,128`)
  * Calls $8503 to run several frames of the animation (`CALL 34051`)
  * Repeats until $8506 is non-zero (`PEEK(34054) <> 0`) indicating <kbd>Esc</kbd> was pressed

The `DEMOLIB` binary contains code for several demo features beyond the animation. This exploration focuses only on the Martymations aspect.

## Image Format

The two files (`PICnA` and `PICnB`) are RLE-compressed Apple II high-resolution graphics screens.

At a coarse level, the Apple II high-resolution graphics screens are made up of 192 rows, with each row comprising 40 bytes, or columns. The bits of each byte create a color pattern in a notoriously complex mechanism, with even and odd bytes within each row behaving differently. In the Apple II's RAM, the first 40 bytes of screen memory represent the first row of the display. But then the next 40 bytes are the 64th row of the screen. Then the next 40 bytes are the 128th byte of the screen. Then 8 bytes are skipped. The next 40 bytes jump back up to the 8th row, then the 72nd row, then the 136th row. Then 8 bytes are again skipped. Eventually this loops back to pick up the 2nd, 65th, and 129th row, and so on.

The RLE compression is specific to this screen format. Rather than progressing through memory, which due to the strange layout is not amenable to memory-ordered run lengths, it follows the screen layout and works column by column. Further, because the animation (see below) only animates every other row, first half of of the rows on the display are compressed, then the other half. In pseudocode:

```
   for offset = 1 to 0 step -1
     for column = 0 to 39
       for row = offset to 192 step 2
         row_ptr = row_table[row]
         row_ptr[column] = data_byte()
```

The first data byte in the stream is read byt not used. Then as each new data byte is read from the stream it is compared with the previous data byte read. If it is the same, the following byte is the run length.

The initialization routine at $8500 calls a decompression routine at $8800 twice. The first time to decompress the data from $4000 (`PICnA`) to $2000 (the first high-resolution graphics page), and the second time to decompress the data from $6000 (`PICnB`) to $4000 (the second graphics page).

The decompression routine is configurable with a table of two-byte operations to perform on each data byte before it is stored in the graphics page, but for Martymations a pair of `NOP` ("no operations") is specified so no transformation is done.

## Animation

The actual color cycling animation is done by showing one of the graphics pages, then operating on the other. It loops over every other row of the display memory, and for each byte value uses it as n index in a lookup table and replaces it with the result. Even and odd bytes on each row are handled using separate tables, because (as noted above) they encoding color patterns differently. Once each byte on every other row has been updated, the updated page is shown and the process repeats on the other page.

The animation tables are not part of the image files, so they are the same for all Martymations. The tables encode color cycles:

For example, if a pair of odd/even bytes are $00/$00 (all black), they will progress through the following values in the tables:

| even | odd  | appearance |
| ---- | ---- | ---------- |
| $00  | $00  | black      |
| $55  | $2A  | violet     |
| $2A  | $55  | green      |
| $7F  | $7F  | white      |
| $00  | $00  | black      |

Byte pairs that encode those colors as subsets of their bit patterns progress through similar cycles.

Another color sequence is available that animates

black  &rarr;
blue   &rarr;
orange &rarr;
white  &rarr;
black

but this appears to not be used by any of the Martymations files.

Since only half the rows are animated, the bytes and hence colors on those rows remain static. Some of the animation files use the same color for those rows across the image, others vary them to produce more subtle color effects. Thanks to blurry CRT displays and the limits of human perception, this gives the appearance of more than 4 colors cycling within a given image.

## Source Code

The source file `demolib.s` is a dissassembly (originally performed using [da65](https://cc65.github.io/doc/da65)) with the parts relevant to Martymations detailed.

Using the tools [ca65](https://cc65.github.io/doc/ca65) and [Cadius](https://github.com/mach-kernel/cadius), you can build the source, verify the result to be identical to the original (`orig/DEMOLIB.BIN`), and create a disk image including the library, a small Applesoft BASIC driver program, and the Martymations.
