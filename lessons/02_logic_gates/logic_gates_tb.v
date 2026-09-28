`timescale 1ns/1ps
module logic_gates_tb;
    reg  [9:0] sw;
    wire [9:0] led;
    reg  [9:0] expected;
    integer i, errors = 0;

    logic_gates dut (.SW(sw), .LEDR(led));

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, logic_gates_tb);
        // Try all 1024 switch combinations and compare against a reference model.
        for (i = 0; i < 1024; i = i + 1) begin
            sw = i;
            #1;
            expected[0]   = sw[0] & sw[1];
            expected[1]   = sw[0] | sw[1];
            expected[2]   = sw[0] ^ sw[1];
            expected[3]   = !(sw[0] & sw[1]);
            expected[4]   = !(sw[0] | sw[1]);
            expected[5]   = !sw[0];
            expected[6]   = sw[2] ? sw[4] : sw[3];
            expected[9:7] = sw[7:6] + sw[9:8];
            if (led !== expected) begin
                $display("FAIL: SW=%b LEDR=%b expected %b", sw, led, expected);
                errors = errors + 1;
            end
        end
        if (errors == 0) $display("PASS: all 1024 switch combinations correct");
        $finish;
    end
endmodule
