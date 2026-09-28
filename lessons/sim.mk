# Shared simulation rules. A lesson's Makefile sets TB and SRCS, then includes this file.
#   make sim   - compile and run the testbench
#   make wave  - run, then open the waveform (wave.vcd) in GTKWave
#   make clean - delete simulation output

IVERILOG ?= iverilog
VVP      ?= vvp
GTKWAVE  ?= gtkwave

.PHONY: sim wave clean

sim: $(TB).vvp
	$(VVP) -n $(TB).vvp

$(TB).vvp: $(SRCS)
	$(IVERILOG) -g2012 -Wall -Wno-timescale -o $@ -s $(TB) $(SRCS)

wave: sim
	$(GTKWAVE) wave.vcd &

clean:
	rm -f *.vvp *.vcd
