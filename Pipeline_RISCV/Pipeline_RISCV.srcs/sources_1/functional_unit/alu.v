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

//==========================================================//
//                           ALU                            //
//==========================================================//

module alu(
    input wire [31:0] operand_a_i,
    input wire [31:0] operand_b_i,
    input wire [4:0]  alu_op_i,
    output reg [31:0] alu_data_o
);

// Add, Sub calculation
    wire [31:0] add_res_w = operand_a_i + operand_b_i;
	wire [31:0] sub_res_w = operand_a_i - operand_b_i;
	
// Shift operation
	wire [31:0] sll_res_w = operand_a_i << operand_b_i[4:0];
	wire [31:0] srl_res_w = operand_a_i >> operand_b_i[4:0];
	
// Arithmetic shift (MSB extension)
	wire [31:0] sra_res_w = $signed(operand_a_i )>>> operand_b_i[4:0];
	
// Comparison
	wire slt_res_w = ($signed(operand_a_i) < $signed(operand_b_i))? 1'b1:1'b0; //signed
	wire sltu_res_w = (operand_a_i < operand_b_i)? 1'b1:1'b0; //unsigned

// Logical calculation
	wire [31:0] and_res_w = operand_a_i & operand_b_i;
	wire [31:0] or_res_w = operand_a_i | operand_b_i;
	wire [31:0] xor_res_w = operand_a_i ^ operand_b_i;
	
// Wire to the correct output
	always @(*) begin
		case(alu_op_i) 
			`ADD: alu_data_o = add_res_w;
			`SUB: alu_data_o = sub_res_w;
			
			`SLL: alu_data_o = sll_res_w;
			`SRL: alu_data_o = srl_res_w;
			`SRA: alu_data_o = sra_res_w;
			
			`SLT: alu_data_o = slt_res_w;
			`SLTU: alu_data_o = sltu_res_w;
			
			`AND: alu_data_o = and_res_w;
			`OR : alu_data_o = or_res_w;
			`XOR: alu_data_o = xor_res_w;
			default: alu_data_o = 32'b0;
	   endcase
	   end
endmodule
