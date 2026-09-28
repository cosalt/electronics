# Setup on macOS

## 1. Simulation (works natively on Mac)

```bash
brew install icarus-verilog     # iverilog + vvp: compile and run Verilog
```

To view waveforms, install one of:

- **GTKWave**: `brew install --cask gtkwave`. The classic viewer; on recent macOS it can be flaky.
- **Surfer**: a modern viewer. Use the web version at <https://app.surfer-project.org> (drag in
  `wave.vcd`) or the "Surfer" VS Code extension.

If you don't use GTKWave, run `make sim` and open `wave.vcd` in Surfer yourself.

Recommended editor: VS Code with the **Verilog-HDL/SystemVerilog** extension (`mshr-h.veriloghdl`).

## 2. Building for the FPGA (needs Windows or Linux)

Intel **Quartus Prime Lite** (free) turns Verilog into a bitstream for the MAX 10. It only runs on
Windows and Linux (x86-64). Options on a Mac:

| Option | Notes |
|---|---|
| A Windows/Linux PC (yours or a school lab) | Easiest and most reliable. |
| Intel Mac + VM (Parallels, VirtualBox, UTM) with Linux or Windows | Works. Pass the USB-Blaster through to the VM to program from inside it. |
| Apple Silicon Mac + Parallels + Windows 11 ARM | Quartus runs under x86 emulation. Slow and not officially supported, but often good enough for small designs. |

When installing Quartus, select **MAX 10 device support**. The download is large; the MAX 10 device
file alone is several GB.

## 3. Programming the board from your Mac

If you build in a VM or on another computer, you can still program the board from macOS with
[openFPGALoader](https://github.com/trabucayre/openFPGALoader), which supports the DE10-Lite's
on-board USB-Blaster:

```bash
brew install openfpgaloader
```

Quartus produces a `.sof` file. openFPGALoader needs it converted to `.svf` first (run this where
Quartus is installed):

```bash
quartus_cpf -c -q 12.0MHz -g 3.3 -n p output_files/blink.sof blink.svf
```

Then, on the Mac with the board plugged in:

```bash
openFPGALoader -b de10lite blink.svf
```

This loads the design into the FPGA's SRAM, so it is lost at power-off. See [QUARTUS.md](QUARTUS.md)
for making it permanent.
