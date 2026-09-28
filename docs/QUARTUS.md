# Building and programming with Quartus Prime Lite

Every lesson already has a Quartus project (`.qpf`) with the device and pins set. You don't have to
create a project or type in pin numbers.

## GUI

1. **File > Open Project** and pick the lesson's `.qpf` (for example `lessons/01_blink/blink.qpf`).
2. **Processing > Start Compilation** (Ctrl+L). Takes a minute or two.
   Check the messages for errors. Warnings are normal; read them anyway, they often point to bugs
   (e.g. "truncated value", "inferred latch").
3. Plug in the board with the USB cable (the USB-Blaster is built in).
   The first time on Windows you must install the driver from `<quartus>/drivers/usb-blaster`.
4. **Tools > Programmer**. Click **Hardware Setup** and pick **USB-Blaster**.
   `output_files/<name>.sof` should already be listed; tick **Program/Configure** and click **Start**.
5. The design runs immediately. Flip the switches.

## Command line

From a lesson folder:

```bash
quartus_sh --flow compile blink                       # synthesize, fit, generate blink.sof
quartus_pgm -m jtag -o "p;output_files/blink.sof"     # program the board
```

## Keeping the design after power-off

A `.sof` loads into SRAM and disappears when the board loses power. To store it in the MAX 10's
internal flash, program the `.pof` file instead:

```bash
quartus_pgm -m jtag -o "p;output_files/blink.pof"
```

If there is no `.pof` in `output_files/`, make one with **File > Convert Programming Files**.
In the GUI, pick the `.pof` in the Programmer. The board then loads your design every time it
powers up (instead of Terasic's demo).

## Useful Quartus tools

- **Tools > Netlist Viewers > RTL Viewer**: see the circuit Quartus built from your Verilog.
  Great for understanding what your code turns into.
- **Compilation Report > Flow Summary**: how many logic elements, registers and pins you used.
- **Timing Analyzer**: confirms the design runs at 50 MHz. Red "setup slack" means it doesn't.
- **Signal Tap Logic Analyzer**: watch real signals inside the running FPGA.

## Starting a new project

Copy a lesson folder, rename the files, and edit the `.qsf`:

- `TOP_LEVEL_ENTITY` is your top module's name.
- Add one `VERILOG_FILE` line per source file.
- Copy the pin blocks you need from [../board/DE10_Lite_pins.qsf](../board/DE10_Lite_pins.qsf).
  Port names in your top module must exactly match the names in the pin assignments.
