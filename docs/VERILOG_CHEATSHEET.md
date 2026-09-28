# Verilog cheat sheet

## Module

```verilog
module name #(parameter WIDTH = 8) (
    input              clk,
    input  [WIDTH-1:0] a,        // bus: bit WIDTH-1 down to bit 0
    output [WIDTH-1:0] y,        // driven by assign
    output reg         flag      // driven inside always
);
    // ...
endmodule
```

## Numbers

| Literal | Meaning |
|---|---|
| `8'd255` | 8-bit decimal |
| `4'b1010` | 4-bit binary |
| `8'hFF` | 8-bit hex |
| `1'b0`, `1'b1` | single bits |
| `'0`, `'1` | all zeros / all ones (SystemVerilog) |

## Wires vs. registers

- `wire`: a connection. Driven by `assign` or a module output.
- `reg`: assigned inside an `always` block. Despite the name, it only becomes a flip-flop if
  it's assigned in a clocked `always @(posedge clk)`.

## Combinational logic (no memory)

```verilog
assign y = sel ? a : b;       // mux
assign sum = a + b;

always @(*) begin             // @(*) = re-run when any input changes
    case (op)
        2'd0:    y = a & b;
        2'd1:    y = a | b;
        default: y = 0;       // always cover every case, or you get a latch
    endcase
end
```

Use **blocking** `=` in combinational `always @(*)` blocks.

## Sequential logic (flip-flops)

```verilog
always @(posedge clk) begin
    if (reset) count <= 0;
    else       count <= count + 1'b1;
end
```

Use **non-blocking** `<=` in clocked blocks. Every `<=` in the block updates at the same moment
(the clock edge), using the values from before the edge.

## Operators

| | |
|---|---|
| `& \| ^ ~` | bitwise AND, OR, XOR, NOT |
| `&& \|\| !` | logical (true/false) |
| `== != < >` | comparison |
| `+ - *` | arithmetic (avoid `/` and `%` except by constants) |
| `<< >>` | shift |
| `{a, b}` | concatenate |
| `{4{a}}` | repeat `a` 4 times |
| `&x`, `\|x`, `^x` | reduce: AND/OR/XOR of all bits of `x` |
| `x[3:0]` | bit slice |

## Instantiating a module

```verilog
hex_to_7seg digit0 (
    .hex(count[3:0]),   // .port_name(signal)
    .seg(HEX0[6:0])
);

blink #(.WIDTH(4)) dut (...);   // override a parameter
```

## Testbench bits (simulation only, not synthesizable)

```verilog
`timescale 1ns/1ps
reg clk = 0;
always #10 clk = ~clk;          // 20 ns period = 50 MHz

initial begin
    $dumpfile("wave.vcd");      // record signals for the waveform viewer
    $dumpvars(0, my_tb);
    #100;                       // wait 100 ns
    $display("x = %d, y = %b", x, y);
    $finish;
end
```

## Common beginner mistakes

- **Latches**: a combinational `always @(*)` that doesn't assign a signal on every path. Add a
  default value at the top of the block or a `default:` case.
- **Assigning one signal from two `always` blocks**: not allowed in hardware.
- **Forgetting active-low**: `KEY` and `HEX` are 0 = pressed / 0 = segment on.
- **Width mismatches**: `count + 1` is 32 bits wide; use `count + 1'b1`. Read Quartus's
  "truncated" warnings.
- **Using async inputs directly**: synchronize buttons and switches with two flip-flops (lesson 04).
- **Thinking in sequence**: Verilog describes hardware that all runs at once, not steps that run
  one after another.
