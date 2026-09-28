`timescale 1ns/1ps
module blink_tb;
    reg clk = 0;
    reg [9:0] sw = 10'b0;
    wire [9:0] led;

    // A 4-bit counter instead of 26 bits so the blink shows up in a short simulation.
    blink #(.WIDTH(4)) dut (.MAX10_CLK1_50(clk), .SW(sw), .LEDR(led));

    always #10 clk = ~clk;   // 50 MHz

    integer toggles = 0;
    always @(led[0]) toggles = toggles + 1;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, blink_tb);
        #200 sw = 10'b1010101010;
        #20;
        if (led[9:1] !== sw[9:1]) $display("FAIL: LEDR[9:1]=%b, expected %b", led[9:1], sw[9:1]);
        #1400;
        if (toggles < 4) $display("FAIL: LEDR[0] toggled only %0d times", toggles);
        else             $display("PASS: LEDR[0] toggled %0d times, switches reach the LEDs", toggles);
        $finish;
    end
endmodule
