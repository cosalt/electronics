// Lesson 03: show the switches as two hex digits.
// SW[3:0] appears on HEX0 and SW[7:4] on HEX1. The other displays are blanked.
module seven_segment (
    input  [9:0] SW,
    output [9:0] LEDR,
    output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
    hex_to_7seg digit0 (.hex(SW[3:0]), .seg(HEX0[6:0]));
    hex_to_7seg digit1 (.hex(SW[7:4]), .seg(HEX1[6:0]));

    assign HEX0[7] = 1'b1;    // decimal points off (active-low)
    assign HEX1[7] = 1'b1;

    assign HEX2 = 8'hFF;      // all segments off
    assign HEX3 = 8'hFF;
    assign HEX4 = 8'hFF;
    assign HEX5 = 8'hFF;

    assign LEDR = SW;         // show the binary value too
endmodule
