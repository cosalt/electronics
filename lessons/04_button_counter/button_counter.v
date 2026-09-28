// Lesson 04: count button presses.
// Press KEY[0] to add one, press KEY[1] to reset. The count shows on HEX1:HEX0 and LEDR.
module button_counter (
    input        MAX10_CLK1_50,
    input  [1:0] KEY,          // active-low: 0 while pressed
    output [9:0] LEDR,
    output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
    wire clk = MAX10_CLK1_50;

    // 1) Synchronize: buttons change at random times relative to the clock. Passing them
    //    through two flip-flops keeps a half-changed (metastable) value out of the design.
    reg [1:0] key0_sync = 2'b11;
    reg [1:0] key1_sync = 2'b11;
    always @(posedge clk) begin
        key0_sync <= {key0_sync[0], KEY[0]};
        key1_sync <= {key1_sync[0], KEY[1]};
    end
    wire key0_down = ~key0_sync[1];
    wire reset     = ~key1_sync[1];

    // 2) Edge detect: a press lasts millions of clock cycles, but we want to count it once.
    //    Compare this cycle with the last one and react only to the not-pressed -> pressed change.
    reg key0_was_down = 1'b0;
    always @(posedge clk)
        key0_was_down <= key0_down;
    wire press = key0_down & ~key0_was_down;

    // 3) The counter itself.
    reg [7:0] count = 8'd0;
    always @(posedge clk) begin
        if (reset)
            count <= 8'd0;
        else if (press)
            count <= count + 1'b1;
    end

    assign LEDR = {2'b00, count};

    hex_to_7seg digit0 (.hex(count[3:0]), .seg(HEX0[6:0]));
    hex_to_7seg digit1 (.hex(count[7:4]), .seg(HEX1[6:0]));
    assign HEX0[7] = 1'b1;
    assign HEX1[7] = 1'b1;
    assign HEX2 = 8'hFF;
    assign HEX3 = 8'hFF;
    assign HEX4 = 8'hFF;
    assign HEX5 = 8'hFF;
endmodule
