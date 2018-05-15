//MIPS PARTS
module alu(input logic [31:0] a, b,
	input logic [3:0] f, // SRLV, XORI
	input logic [4:0] shamt, // SLL, SRL
	output logic [31:0] y, output zero);


logic [31:0] s, bout;
assign bout = f[3] ? ~b : b;
assign s = a + bout + f[3];
always_comb
case (f[2:0])
	3'b000: y <= a & bout;
	3'b001: y <= a | bout;
	3'b010: y <= s;
	3'b011: y <= s[31];
	3'b100: y <= s << shamt;
	3'b101: y <= s >> shamt;
endcase
assign zero = (y == 32'b0);
endmodule


module adder(input  logic [31:0] a, b,
             output logic [31:0] y);

  assign y = a + b;
endmodule


module sl2(input  logic [31:0] a,
           output logic [31:0] y);

  // shift left by 2
  assign y = {a[29:0], 2'b00};
endmodule


module signext(input  logic [15:0] a,
               output logic [31:0] y);
              
  assign y = {{16{a[15]}}, a};
endmodule

module signext8(input logic [7:0] a,
		output logic [31:0] y);

  assign y = {{24{a[7]}}, a};
endmodule


module flopr #(parameter WIDTH = 8)
              (input  logic             clk, reset,
               input  logic [WIDTH-1:0] d, 
               output logic [WIDTH-1:0] q);

  always_ff @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;
endmodule


module flopenr #(parameter WIDTH = 8)
                (input  logic             clk, reset,
                 input  logic             en,
                 input  logic [WIDTH-1:0] d, 
                 output logic [WIDTH-1:0] q);
 
  always_ff @(posedge clk, posedge reset)
    if      (reset) q <= 0;
    else if (en)    q <= d;
endmodule


module mux2 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, 
              input  logic             s, 
              output logic [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule


module mux3 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, d2,
              input  logic [1:0]       s, 
              output logic [WIDTH-1:0] y);

  assign #1 y = s[1] ? d2 : (s[0] ? d1 : d0); 
endmodule


module mux4 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, d2, d3,
              input  logic [1:0]       s, 
              output logic [WIDTH-1:0] y);

   always_comb
      case(s)
         2'b00: y <= d0;
         2'b01: y <= d1;
         2'b10: y <= d2;
         2'b11: y <= d3;
      endcase
endmodule


module floprc #(parameter WIDTH = 8)
	(input logic clk, reset,clear,
	 input logic [WIDTH-1:0] d,
	 output logic [WIDTH-1:0] q);

always_ff @(posedge clk, posedge reset)

if (reset) q <= #1 0;
else if (clear) q <= #1 0;
else q <= #1 d;
endmodule


module flopenrc #(parameter WIDTH = 8)
	(input logic clk, reset,
 	 input logic en, clear,
	 input logic [WIDTH-1:0] d,
	 output logic [WIDTH-1:0] q);

always_ff @(posedge clk, posedge reset)

if (reset) q <= #1 0;
else if (clear) q <= #1 0;
else if (en) q <= #1 d;
endmodule


module eqcmp(input logic[31:0] a, b,
	     output logic isEqual);
assign isEqual = a === b ? 1'b1 : 1'b0;
endmodule

//MIPS division and multiplication unit
module multdivunit(input logic [31:0] a, b,
		input logic multordiv,
		output logic [31:0] hi, lo);

always_comb
if (multordiv)
	assign {hi, lo} = a * b;
else
	begin
	assign lo = a / b;
	assign hi = a % b;
	end

endmodule


//assigning high and low
module hiandlo(input logic clk, we,
		input logic [31:0] wdhi, wdlo,
		output logic [31:0] rdhi, rdlo);

logic [31:0] hi, lo;
always
	begin
	if(clk)
	    if (we)
		begin
		hi <= wdhi;
		lo <= wdlo;
		end
	#5;
	assign rdhi = hi;
	assign rdlo = lo;
	end
endmodule
