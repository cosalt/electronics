# 03 · Seven-segment display

**Goal:** decoders, `case` statements, and reusing a module more than once.

## How it works

Each digit has seven segments named `a`–`g`. [`lib/hex_to_7seg.v`](../../lib/hex_to_7seg.v) is a
lookup table from a 4-bit number to the segments that should light. It's instantiated twice:
`SW[3:0]` shows on `HEX0`, `SW[7:4]` on `HEX1`.

The DE10-Lite segments are **active-low**: drive a 0 to light a segment. `HEXn[7]` is the decimal
point. Unused displays are set to `8'hFF` (all off).

## Simulate

```bash
make sim
```

The testbench draws each digit as ASCII art, so you can check the decoder without a board.

## Exercises

1. Turn on the decimal point of `HEX0` when `SW[9]` is up.
2. Show `SW[9:8]` on `HEX2`.
3. Make a decimal decoder: show `SW[3:0]` as 0–15 in decimal across `HEX1:HEX0`.
   (Hint: if the value is 10 or more, the tens digit is 1 and the ones digit is `value - 10`.)
4. Spell `HELLO` across the displays. Which letters can a seven-segment digit show?
