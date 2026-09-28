// Lesson 01: blink an LED.
// A counter increments on every clock edge; its top bit toggles slowly enough to see.
module blink #(
    parameter WIDTH = 26        // 2^26 cycles / 50 MHz ≈ 1.34 s per on/off cycle
) (
    input        MAX10_CLK1_50,
    input  [9:0] SW,
    output [9:0] LEDR
);
    reg [WIDTH-1:0] count = 0;

    always @(posedge MAX10_CLK1_50)
        count <= count + 1'b1;

    assign LEDR[0]   = count[WIDTH-1];   // blinks at roughly 0.75 Hz
    assign LEDR[9:1] = SW[9:1];          // switches drive LEDs directly
endmodule
