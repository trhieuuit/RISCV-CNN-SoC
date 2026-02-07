`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2026 07:18:47 AM
// Design Name: 
// Module Name: mul
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "encoding.v"
module mul(
    input [31:0] mul_a_i,
    input [31:0]mul_b_i,
	input [4:0] mul_op_i,
	output reg [31:0] mul_data_o
    );
	
	wire signed [63:0] prod_signed_signed;
	wire [63:0] prod_unsigned_unsigned;
	wire signed [63:0] prod_signed_unsigned;
//signedxsigned	
	assign prod_signed_signed = $signed(mul_a_i) * $signed(mul_b_i);
//unsigned x unsigned	
	assign prod_unsigned_unsigned = mul_a_i * mul_b_i;
//signedx unsigned
	assign prod_signed_unsigned = $signed(mul_a_i) * $signed({1'b0,mul_b_i});
	
	always @(*) begin
		case(mul_op_i)
			`MUL: mul_data_o = prod_signed_signed[31:0];
			`MULH: mul_data_o = prod_signed_signed[63:32];
			`MULHU: mul_data_o = prod_unsigned_unsigned[63:32];
			`MULHSU: mul_data_o = prod_signed_unsigned[63:32];
		endcase
	end
	
endmodule
