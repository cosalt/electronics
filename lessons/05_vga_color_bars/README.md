# 05 · VGA colour bars

**Goal:** timing-driven design. Generate a video signal a monitor understands.

You need a VGA monitor (or an HDMI monitor with a VGA-to-HDMI adapter that has its own power).
`SW0` down shows eight colour bars; `SW0` up shows a checkerboard.

## How it works

A VGA monitor draws the picture one line at a time, left to right, top to bottom. For 640×480 at
60 Hz:

```
Horizontal (pixels):  640 visible | 16 front porch | 96 HSYNC | 48 back porch  = 800
Vertical   (lines):   480 visible | 10 front porch |  2 VSYNC | 33 back porch  = 525
```

The design has two counters, `x` (0–799) and `y` (0–524), that advance at the pixel rate (25 MHz,
every other 50 MHz clock). From them it makes the sync pulses and picks a colour for the current
pixel. During the porches and sync the colour must be black.

The DE10-Lite has 4 bits per colour (4096 colours) through a resistor network. This lesson only
uses fully on or off.

## Simulate

```bash
make sim     # measures the line and frame period
make wave    # waveform of the first two lines
```

## Exercises

1. Use `SW[3:1]` to pick a solid colour for the whole screen.
2. Draw a white border 1 pixel wide around the screen.
3. Draw a 32×32 square at a position set by the switches.
4. Make the square bounce around the screen. (Update its position once per frame, when `y` wraps.)
5. Use all 4 bits: draw a smooth gradient from black to red across the screen.
