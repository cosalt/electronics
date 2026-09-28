`timescale 1ns/1ps
module blink_tb;
    reg clk = 0;
    reg [9:0] sw = 10'b0;
    wire [9:0] led;

    top dut (.MAX10_CLK1_50(clk), .SW(sw), .LEDR(led));

    always #10 clk = ~clk;   // 50 MHz

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, blink_tb);
        #200 sw = 10'b1010101010;
        #400 $finish;
    end
endmodule
