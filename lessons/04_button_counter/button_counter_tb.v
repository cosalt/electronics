`timescale 1ns/1ps
module button_counter_tb;
    reg clk = 0;
    reg [1:0] key = 2'b11;     // both released
    wire [9:0] led;
    wire [7:0] hex0, hex1, hex2, hex3, hex4, hex5;
    integer errors = 0;

    button_counter dut (.MAX10_CLK1_50(clk), .KEY(key), .LEDR(led),
                        .HEX0(hex0), .HEX1(hex1), .HEX2(hex2),
                        .HEX3(hex3), .HEX4(hex4), .HEX5(hex5));

    always #10 clk = ~clk;

    // Hold a button down for a while, then release it.
    task press(input integer which);
        begin
            key[which] = 1'b0;
            #500;
            key[which] = 1'b1;
            #500;
        end
    endtask

    task expect_count(input [7:0] value);
        begin
            if (led[7:0] !== value) begin
                $display("FAIL: count=%0d, expected %0d", led[7:0], value);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, button_counter_tb);
        #100;
        expect_count(0);
        press(0); expect_count(1);
        press(0); expect_count(2);
        press(0); expect_count(3);
        press(1); expect_count(0);   // reset
        press(0); expect_count(1);
        if (errors == 0) $display("PASS: one count per press, reset works");
        $finish;
    end
endmodule
