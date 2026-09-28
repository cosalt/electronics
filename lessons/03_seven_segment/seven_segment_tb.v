`timescale 1ns/1ps
module seven_segment_tb;
    reg  [9:0] sw = 0;
    wire [9:0] led;
    wire [7:0] hex0, hex1, hex2, hex3, hex4, hex5;
    integer i;

    seven_segment dut (.SW(sw), .LEDR(led), .HEX0(hex0), .HEX1(hex1),
                       .HEX2(hex2), .HEX3(hex3), .HEX4(hex4), .HEX5(hex5));

    // Draw a digit as ASCII art. Segments are active-low, so 0 = lit.
    task draw(input [7:0] s);
        begin
            $display(" %s ",   s[0] ? "   " : "---");
            $display("%s   %s", s[5] ? " " : "|", s[1] ? " " : "|");
            $display(" %s ",   s[6] ? "   " : "---");
            $display("%s   %s", s[4] ? " " : "|", s[2] ? " " : "|");
            $display(" %s ",   s[3] ? "   " : "---");
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, seven_segment_tb);
        for (i = 0; i < 16; i = i + 1) begin
            sw[3:0] = i;
            #1;
            $display("SW[3:0] = %h", i[3:0]);
            draw(hex0);
        end
        if (hex2 === 8'hFF && hex5 === 8'hFF) $display("PASS: unused displays are blank");
        else                                  $display("FAIL: unused displays are not blank");
        $finish;
    end
endmodule
