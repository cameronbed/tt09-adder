/* (c) Krishna Subramanian <https://github.com/mongrelgem>
 * For Issues & Bugs, report to <https://github.com/mongrelgem/Verilog-Adders/issues>
*/
module BigCircle(output G, P, input Gi, Pi, GiPrev, PiPrev);
  wire e;
  and #(1) (e, Pi, GiPrev);
  or #(1) (G, e, Gi);
  and #(1) (P, Pi, PiPrev);
endmodule

module HA8(output [7:0] sum, output cout, input [7:0] a, b);
  // KSA + CLA
  CLA4 cla4(sum[3:0], cout_1, a[3:0], b[3:0], 1'b0);
  KSA4 ksa4(sum[7:4], cout, a[7:4], b[7:4], cout_1);
endmodule

module CLA4(output [3:0] sum, output cout, input [3:0] a, b, input cin);
  wire [3:0] g, p, c;
  wire [135:0] e;
  //c[0]
  and #(1) (e[0], cin, p[0]);
  or #(1) (c[0], e[0], g[0]);

  //c[1]
  and #(1) (e[1], cin, p[0], p[1]);
  and #(1) (e[2], g[0], p[1]);
  or #(1) (c[1], e[1], e[2], g[1]);

  //c[2]
  and #(1) (e[3], cin, p[0], p[1], p[2]);
  and #(1) (e[4], g[0], p[1], p[2]);
  and #(1) (e[5], g[1], p[2]);
  or #(1) (c[2], e[3], e[4], e[5], g[2]);

  //c[3]
  and #(1) (e[6], cin, p[0], p[1], p[2], p[3]);
  and #(1) (e[7], g[0], p[1], p[2], p[3]);
  and #(1) (e[8], g[1], p[2], p[3]);
  and #(1) (e[9], g[2], p[3]);
  or #(1) (c[3], e[6], e[7], e[8], e[9], g[3]);

  xor #(2) (sum[0],p[0],cin);
  xor #(2) x[3:1](sum[3:1],p[3:1],c[2:0]);
  buf #(1) (cout, c[3]);
  PGGen pggen[3:0](g[3:0],p[3:0],a[3:0],b[3:0]);
endmodule

module KSA4(output [3:0] sum, output cout, input [3:0] a, b, input cin);
  wire [3:0] c;
  wire [3:0] g, p;
  Square sq[3:0](g, p, a, b);

  // first line of circles
  wire [3:1] g2, p2;
  SmallCircle sc0_0(c[0], g[0]);
  BigCircle bc0[3:1](g2[3:1], p2[3:1], g[3:1], p[3:1], g[2:0], p[2:0]);

  // second line of circle
  wire [3:3] g3, p3;
  SmallCircle sc1[2:1](c[2:1], g2[2:1]);
  BigCircle bc1[3:3](g3[3:3], p3[3:3], g2[3:3], p2[3:3], g2[1:1], p2[1:1]);

  // fourth line of circle
  SmallCircle sc3_7(c[3], g3[3]);

  // last line - triangles
  Triangle tr0(sum[0], p[0], cin);
  Triangle tr[3:1](sum[3:1], p[3:1], c[2:0]);

  // generate cout
  buf #(1) (cout, c[3]);
endmodule

module PGGen(output g, p, input a, b);
  and #(1) (g, a, b);
  xor #(2) (p, a, b);
endmodule

module SmallCircle(output Ci, input Gi);
  buf #(1) (Ci, Gi);
endmodule

module Square(output G, P, input Ai, Bi);
  and #(1) (G, Ai, Bi);
  xor #(2) (P, Ai, Bi);
endmodule

module Triangle(output Si, input Pi, CiPrev);
  xor #(2) (Si, Pi, CiPrev);
endmodule
