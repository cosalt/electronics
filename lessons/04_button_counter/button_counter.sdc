# Timing constraints: tell Quartus the board clock is 50 MHz (20 ns period).
create_clock -name clk50 -period 20.000 [get_ports MAX10_CLK1_50]
derive_clock_uncertainty
