# 01 · Blink

**Goal:** get a design onto the board and learn clocks, registers and counters.

## How it works

The board has a 50 MHz oscillator: `MAX10_CLK1_50` goes high 50 million times a second. On every
rising edge (`posedge`) a 26-bit counter adds one. Each bit of a counter toggles half as often as
the one below it, so bit 25 toggles every 2^25 clocks ≈ 0.67 s. We wire that bit to `LEDR[0]`.

`LEDR[9:1]` are wired straight to `SW[9:1]` to prove the pins are right.

## Simulate

```bash
make sim     # prints PASS/FAIL
make wave    # open the waveform: look at clk, count, and led[0]
```

The testbench sets `WIDTH` to 4 so the LED toggles within a few hundred nanoseconds instead of
waiting 67 million clock cycles.

## On the board

Open `blink.qpf` in Quartus, compile, program (see [docs/QUARTUS.md](../../docs/QUARTUS.md)).
`LEDR0` blinks and switches 1–9 light the LEDs above them.

## Exercises

1. Make the LED blink twice as fast. (Which bit should you use?)
2. Show `count[25:16]` on all ten LEDs. What pattern do you see?
3. Use `SW[0]` to choose between a fast and a slow blink.
4. Make exactly a 1 Hz blink: count to 24,999,999, reset to 0, and toggle an LED register each time.
