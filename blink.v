module top (
    input  MAX10_CLK1_50,
    input  [9:0] SW,
    output [9:0] LEDR
);
    reg [25:0] count;

    always @(posedge MAX10_CLK1_50)
        count <= count + 1;

    assign LEDR[0]   = count[25];   // blinks at roughly 0.7 Hz
    assign LEDR[9:1] = SW[9:1];     // switches drive LEDs directly
endmodule
