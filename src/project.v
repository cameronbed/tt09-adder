/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_hybrid_adder (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  wire cout;
  wire [7:0] sum, a, b;

  assign uo_out = sum;
  assign a = ui_in;
  assign b = uio_in;

  HA8 adder(
    .sum(sum),
    .cout(cout),
    .a(a),
    .b(b)
  );

  assign uio_oe = 0;
  assign uio_out = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, cout, 1'b0};

endmodule
