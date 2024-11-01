module BigCircle(output G, P, input Gi, Pi, GiPrev, PiPrev);
  wire e;
  and (e, Pi, GiPrev);
  or (G, e, Gi);
  and (P, Pi, PiPrev);
endmodule

module GrayCircle(output G, input Gi, Pi, GiPrev);
  wire e;
  and (e, Pi, GiPrev);
  or (G, e, Gi);
endmodule

module SmallCircle(output Ci, input Gi);
  assign Ci = Gi;
endmodule

module Square(output G, P, input Ai, Bi);
  and (G, Ai, Bi);
  xor (P, Ai, Bi);
endmodule

module Triangle(output Si, input Pi, CiPrev);
  xor (Si, Pi, CiPrev);
endmodule

module KSA4(output [3:0] sum, output cout, input [3:0] a, b, input cin);

  wire [3:0] c;
  wire [3:0] g, p;
  
  // Manually instantiate Squares
  Square sq0(g[0], p[0], a[0], b[0]);
  Square sq1(g[1], p[1], a[1], b[1]);
  Square sq2(g[2], p[2], a[2], b[2]);
  Square sq3(g[3], p[3], a[3], b[3]);

  // Declare individual wires
  wire g1_0, g1_1, g1_2;
  wire p1_0, p1_1, p1_2;
  
  // First level of BigCircles
  BigCircle bc1_0(g1_0, p1_0, g[1], p[1], g[0], p[0]);
  BigCircle bc1_1(g1_1, p1_1, g[2], p[2], g[1], p[1]);
  BigCircle bc1_2(g1_2, p1_2, g[3], p[3], g[2], p[2]);

  // Second level of BigCircles
  wire g2_0, g2_1;
  wire p2_0, p2_1;
  BigCircle bc2_0(g2_0, p2_0, g1_1, p1_1, g[0], p[0]);
  BigCircle bc2_1(g2_1, p2_1, g1_2, p1_2, g1_0, p1_0);
  
  // GrayCircles
  GrayCircle bc3_0(c[0], g[0], p[0], cin);
  GrayCircle bc3_1(c[1], g1_0, p1_0, cin);
  GrayCircle bc3_2(c[2], g2_0, p2_0, cin);
  GrayCircle bc3_3(c[3], g2_1, p2_1, cin);

  // Triangles
  Triangle tr0(sum[0], p[0], cin);
  Triangle tr1(sum[1], p[1], c[0]);
  Triangle tr2(sum[2], p[2], c[1]);
  Triangle tr3(sum[3], p[3], c[2]);

  assign cout = c[3];

endmodule

module CLA4(output [3:0] sum, output cout, input [3:0] a, b);
  wire [3:0] g, p, c;
  wire [9:0] e;
  wire cin;

  assign cin = 1'b0;

  // Manually instantiate Squares
  Square sq0(g[0], p[0], a[0], b[0]);
  Square sq1(g[1], p[1], a[1], b[1]);
  Square sq2(g[2], p[2], a[2], b[2]);
  Square sq3(g[3], p[3], a[3], b[3]);

  // c[0]
  and (e[0], cin, p[0]);
  or  (c[0], e[0], g[0]);

  // c[1]
  and (e[1], cin, p[0], p[1]);
  and (e[2], g[0], p[1]);
  or  (c[1], e[1], e[2], g[1]);

  // c[2]
  and (e[3], cin, p[0], p[1], p[2]);
  and (e[4], g[0], p[1], p[2]);
  and (e[5], g[1], p[2]);
  or  (c[2], e[3], e[4], e[5], g[2]);

  // c[3]
  and (e[6], cin, p[0], p[1], p[2], p[3]);
  and (e[7], g[0], p[1], p[2], p[3]);
  and (e[8], g[1], p[2], p[3]);
  and (e[9], g[2], p[3]);
  or  (c[3], e[6], e[7], e[8], e[9], g[3]);

  // Sum bits
  xor (sum[0], p[0], cin);
  xor (sum[1], p[1], c[0]);
  xor (sum[2], p[2], c[1]);
  xor (sum[3], p[3], c[2]);

  assign cout = c[3];

endmodule

module HA8(output [7:0] sum, output cout, input [7:0] a, b);

  wire cout_1;
  CLA4 cla4(.sum(sum[3:0]), .cout(cout_1), .a(a[3:0]), .b(b[3:0]));
  KSA4 ksa4(.sum(sum[7:4]), .cout(cout), .a(a[7:4]), .b(b[7:4]), .cin(cout_1));

endmodule
