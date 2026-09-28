// Lesson 05: drive a VGA monitor at 640x480, 60 Hz.
// SW[0] off shows colour bars, SW[0] on shows a checkerboard.
module vga_color_bars (
    input        MAX10_CLK1_50,
    input  [9:0] SW,
    output reg [3:0] VGA_R = 0,
    output reg [3:0] VGA_G = 0,
    output reg [3:0] VGA_B = 0,
    output reg       VGA_HS = 1,
    output reg       VGA_VS = 1
);
    // Standard 640x480 @ 60 Hz timing, counted in pixels and lines.
    localparam H_VISIBLE = 640, H_FRONT = 16, H_SYNC = 96, H_BACK = 48;
    localparam V_VISIBLE = 480, V_FRONT = 10, V_SYNC = 2,  V_BACK = 33;
    localparam H_TOTAL = H_VISIBLE + H_FRONT + H_SYNC + H_BACK;   // 800
    localparam V_TOTAL = V_VISIBLE + V_FRONT + V_SYNC + V_BACK;   // 525

    wire clk = MAX10_CLK1_50;

    // The pixel clock should be 25.175 MHz. Doing work on every other 50 MHz
    // cycle gives 25 MHz, which is close enough for monitors to lock on.
    reg pixel_tick = 1'b0;
    always @(posedge clk)
        pixel_tick <= ~pixel_tick;

    // Beam position: x moves across a line, y moves down the screen.
    reg [9:0] x = 0;
    reg [9:0] y = 0;
    always @(posedge clk) begin
        if (pixel_tick) begin
            if (x == H_TOTAL - 1) begin
                x <= 0;
                y <= (y == V_TOTAL - 1) ? 10'd0 : y + 1'b1;
            end else begin
                x <= x + 1'b1;
            end
        end
    end

    wire visible = (x < H_VISIBLE) && (y < V_VISIBLE);

    // Eight 80-pixel bars: white, yellow, cyan, green, magenta, red, blue, black.
    wire [3:0] bar  = x / 80;
    wire [2:0] bars = {~bar[1], ~bar[2], ~bar[0]};           // {red, green, blue}
    wire [2:0] squares = {3{x[5] ^ y[5]}};                   // 32-pixel squares
    wire [2:0] rgb  = SW[0] ? squares : bars;

    // Register the outputs so every signal leaves the FPGA at the same time.
    always @(posedge clk) begin
        if (pixel_tick) begin
            VGA_R  <= (visible && rgb[2]) ? 4'hF : 4'h0;
            VGA_G  <= (visible && rgb[1]) ? 4'hF : 4'h0;
            VGA_B  <= (visible && rgb[0]) ? 4'hF : 4'h0;
            // Sync pulses are active-low for this video mode.
            VGA_HS <= ~((x >= H_VISIBLE + H_FRONT) && (x < H_VISIBLE + H_FRONT + H_SYNC));
            VGA_VS <= ~((y >= V_VISIBLE + V_FRONT) && (y < V_VISIBLE + V_FRONT + V_SYNC));
        end
    end
endmodule
