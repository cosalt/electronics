# electronics

Learning FPGAs with the **Terasic DE10-Lite** (Intel MAX 10, `10M50DAF484C7G`) and Verilog.

## What's here

```
lessons/              Step-by-step projects. Do them in order.
  01_blink/           A counter that blinks an LED
  02_logic_gates/     AND/OR/XOR, a multiplexer and an adder on the switches
  03_seven_segment/   Show switch values as hex digits
  04_button_counter/  Count button presses (synchronizers, edge detection)
  05_vga_color_bars/  Drive a VGA monitor at 640x480
  sim.mk              Shared simulation rules
lib/                  Reusable modules (hex_to_7seg.v)
board/                Pin and clock reference for the whole board
docs/                 Setup, Quartus workflow, Verilog cheat sheet
```

Each lesson folder has:

| File | What it is |
|---|---|
| `README.md` | What the lesson teaches, what to try on the board, exercises |
| `<name>.v` | The design |
| `<name>_tb.v` | A testbench that checks the design in simulation |
| `<name>.qpf` / `.qsf` | Quartus project: device, source files, pin assignments |
| `<name>.sdc` | Timing constraints (clock speed) |
| `Makefile` | `make sim` / `make wave` |

## Getting started

1. **Simulate on your Mac** (no board needed). See [docs/SETUP_MAC.md](docs/SETUP_MAC.md).
   ```bash
   brew install icarus-verilog
   make test                            # run every lesson's testbench
   cd lessons/01_blink && make wave     # run one and look at the waveform
   ```
2. **Build and program the board** with Quartus Prime Lite. See [docs/QUARTUS.md](docs/QUARTUS.md).
   Quartus runs on Windows and Linux only, so on a Mac you need a PC or VM to build.
3. Keep [docs/VERILOG_CHEATSHEET.md](docs/VERILOG_CHEATSHEET.md) open while you work.

## The workflow

```
write Verilog  ->  simulate (iverilog)  ->  build (Quartus)  ->  program the board  ->  test with switches/LEDs
      ^                    |
      +---- fix bugs ------+       Simulating first is much faster than rebuilding the FPGA.
```

## Board quick reference

| Signal | Width | Notes |
|---|---|---|
| `MAX10_CLK1_50` | 1 | 50 MHz clock (20 ns period) |
| `SW` | 10 | Slide switches, 1 = up |
| `KEY` | 2 | Push buttons, **active-low** (0 = pressed) |
| `LEDR` | 10 | Red LEDs, 1 = on |
| `HEX0`–`HEX5` | 8 each | Seven-segment digits, **active-low**; bit 7 is the decimal point |
| `VGA_R/G/B` | 4 each | VGA colour, plus `VGA_HS` / `VGA_VS` sync |

Full pin list: [board/DE10_Lite_pins.qsf](board/DE10_Lite_pins.qsf). For SDRAM, the accelerometer, GPIO
and Arduino headers, generate a top-level with Terasic's **System Builder** from the
[DE10-Lite resources page](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=1021)
(the "CD-ROM" download also has the user manual and schematics).

## Next ideas after lesson 05

- Stopwatch on the six HEX displays (clock divider + BCD counters)
- Moving square on VGA controlled by the buttons
- UART transmitter through the Arduino header and a USB-serial adapter
- Read the on-board accelerometer over SPI
- A tiny CPU
