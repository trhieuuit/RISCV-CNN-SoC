`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2026 12:09:31 AM
// Design Name: 
// Module Name: imme_gen
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
module imme_gen(
	input [24:0] in,  // instruction[31:7]
	input [2:0] imm_sel,
	output reg [31:0] out
);

    wire [31:0] U_OUT, J_OUT, B_OUT, I_SIGN_OUT, I_UNSIGN_OUT, S_OUT, I_SHIFT_OUT;

//U-type Imme
    assign U_OUT = {in[24:5], 12'b0};
//J Type Imme
    assign J_OUT = {{12{in[24]}}, in[12:5], in[13], in[23:14], 1'b0};
//B Type Imme
    assign B_OUT = {{20{in[24]}}, in[0], in[23:18], in[4:1], 1'b0};
//I Type Imme
    assign I_SIGN_OUT = {{20{in[24]}}, in[24:13]};
//IU --> unsigned extend Immediate
    assign I_UNSIGN_OUT = {20'b0, in[24:13]};
//S Type Imme
    assign S_OUT = {{20{in[24]}}, in[24:18], in[4:0]};
   // SFT 
    assign I_SHIFT_OUT = {27'b0, in[17:13]};

    always @(*) begin
        case(imm_sel)
            `U_TYPE: out = U_OUT;
            `J_TYPE: out = J_OUT;
            `S_TYPE: out = S_OUT;
            `B_TYPE: out = B_OUT;     
            `I_SIGNED_TYPE: out = I_SIGN_OUT;          
            `I_SHIFT_TYPE: out = I_SHIFT_OUT;         
            `I_UNSIGNED_TYPE: out = I_UNSIGN_OUT;           
            default: out = 0 ;  
                                
        endcase 
    end
endmodule
