`timescale 1ns/1ps
// Checks the sync timing. A full frame is ~840,000 clock cycles, so the waveform is
// only recorded for the first two lines to keep wave.vcd small.
module vga_color_bars_tb;
    reg clk = 0;
    reg [9:0] sw = 0;
    wire [3:0] r, g, b;
    wire hs, vs;

    vga_color_bars dut (.MAX10_CLK1_50(clk), .SW(sw),
                        .VGA_R(r), .VGA_G(g), .VGA_B(b), .VGA_HS(hs), .VGA_VS(vs));

    always #10 clk = ~clk;

    realtime hs_fall = 0, vs_fall = 0, line_ns = 0, frame_ns = 0;
    always @(negedge hs) begin
        if (hs_fall > 0) line_ns = $realtime - hs_fall;
        hs_fall = $realtime;
    end
    always @(negedge vs) begin
        if (vs_fall > 0) frame_ns = $realtime - vs_fall;
        vs_fall = $realtime;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, vga_color_bars_tb);
        #64000 $dumpoff;
        wait (frame_ns > 0);
        $display("line  period: %0.2f us (expect 32.00 -> %0.2f kHz)", line_ns / 1000, 1e6 / line_ns);
        $display("frame period: %0.3f ms (expect 16.800 -> %0.2f Hz)", frame_ns / 1e6, 1e9 / frame_ns);
        if (line_ns == 32000 && frame_ns == 16800000) $display("PASS: VGA timing correct");
        else                                          $display("FAIL: VGA timing wrong");
        $finish;
    end
endmodule
