// Lesson 02: combinational logic. No clock: outputs change as soon as inputs change.
module logic_gates (
    input  [9:0] SW,
    output [9:0] LEDR
);
    wire a = SW[0];
    wire b = SW[1];

    assign LEDR[0] = a & b;       // AND
    assign LEDR[1] = a | b;       // OR
    assign LEDR[2] = a ^ b;       // XOR
    assign LEDR[3] = ~(a & b);    // NAND
    assign LEDR[4] = ~(a | b);    // NOR
    assign LEDR[5] = ~a;          // NOT

    // 2-to-1 multiplexer: SW[2] selects SW[3] (off) or SW[4] (on).
    assign LEDR[6] = SW[2] ? SW[4] : SW[3];

    // 2-bit adder: SW[7:6] + SW[9:8] gives a 3-bit sum on LEDR[9:7].
    assign LEDR[9:7] = SW[7:6] + SW[9:8];
endmodule
