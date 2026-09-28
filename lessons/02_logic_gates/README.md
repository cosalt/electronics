# 02 · Logic gates

**Goal:** combinational logic, where outputs depend only on current inputs (no clock, no memory).

## Switch / LED map

| LED | Function |
|---|---|
| LEDR0 | `SW0 AND SW1` |
| LEDR1 | `SW0 OR SW1` |
| LEDR2 | `SW0 XOR SW1` |
| LEDR3 | `SW0 NAND SW1` |
| LEDR4 | `SW0 NOR SW1` |
| LEDR5 | `NOT SW0` |
| LEDR6 | Mux: shows `SW3` when `SW2` is down, `SW4` when `SW2` is up |
| LEDR9–7 | `SW7:6 + SW9:8`, a 2-bit + 2-bit adder with a 3-bit result |

## Simulate

```bash
make sim
```

The testbench tries all 1024 switch combinations and checks each against a reference model.
This is **exhaustive testing**, possible only because there are few inputs.

## Exercises

1. Write out the truth table for XOR, then check it on the board.
2. Build XOR using only NAND gates (`~(x & y)`). It takes four.
3. Make a 4-bit adder: `SW[3:0] + SW[7:4]` on `LEDR[4:0]`. Why 5 LEDs?
4. In Quartus, open **Tools > Netlist Viewers > RTL Viewer** and find each gate.
