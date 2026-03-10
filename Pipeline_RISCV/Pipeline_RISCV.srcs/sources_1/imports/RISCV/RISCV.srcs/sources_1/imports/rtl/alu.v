`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2026 11:44:07 PM
// Design Name: 
// Module Name: alu
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

//`include "encoding.v"
module alu(
    input [31:0] operand_a_i,
     input [31:0] operand_b_i,
      input [4:0] alu_op_i,
      output reg [31:0] alu_data_o
);
//add,sub
    wire [31:0] add_res = operand_a_i + operand_b_i;
	wire [31:0] sub_res = operand_a_i - operand_b_i;
//shift operation
	wire [31:0] sll_res = operand_a_i <<operand_b_i[4:0];
	wire [31:0] srl_res = operand_a_i >>operand_b_i[4:0];
// arithmetic shift
	wire [31:0] sra_res = $signed(operand_a_i )>>>operand_b_i[4:0];
// compare
	wire slt_res = ($signed(operand_a_i) < $signed(operand_b_i))? 1'b1:1'b0; //signed
	 
	wire sltu_res = (operand_a_i < operand_b_i)? 1'b1:1'b0; //unsigned

//LOGICAL
	wire [31:0] and_res = operand_a_i & operand_b_i;
	wire [31:0] or_res = operand_a_i | operand_b_i;
	wire [31:0] xor_res = operand_a_i ^ operand_b_i;
	

	always @(*) begin
		case(alu_op_i) 
			`ADD: alu_data_o = add_res;
			`SUB: alu_data_o = sub_res;
			
			`SLL: alu_data_o = sll_res	;
			`SRL: alu_data_o = srl_res;
			`SRA: alu_data_o = sra_res;
			
			`SLT: alu_data_o = slt_res;
			`SLTU: alu_data_o = sltu_res;
			
			`AND: alu_data_o = and_res;
			`OR : alu_data_o = or_res;
			`XOR: alu_data_o = xor_res;
			default: alu_data_o = 32'b0;
	   endcase
	   end
endmodule
