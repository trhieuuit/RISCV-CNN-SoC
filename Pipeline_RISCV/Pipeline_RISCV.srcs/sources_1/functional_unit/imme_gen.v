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

module imme_gen(
	input [24:0] in_i,  // instruction[31:7]
	input [2:0] imm_sel_i,
	output reg [31:0] out_o
);

//==========================================================//
//                 Immediate Generator                      //
//==========================================================//
//Calculate all outputs
    wire [31:0] U_OUT_w, J_OUT_w, B_OUT_w, I_SIGN_OUT_w, I_UNSIGN_OUT_w, S_OUT_w, I_SHIFT_OUT_w;
//U-type Imme
    assign U_OUT_w = {in_i[24:5], 12'b0};
//J Type Imme
    assign J_OUT_w = {{12{in_i[24]}}, in_i[12:5], in_i[13], in_i[23:14], 1'b0};
//B Type Imme
    assign B_OUT_w = {{20{in_i[24]}}, in_i[0], in_i[23:18], in_i[4:1], 1'b0};
//I Type Imme
    assign I_SIGN_OUT_w = {{20{in_i[24]}}, in_i[24:13]};
//IU --> unsigned extend Immediate
    assign I_UNSIGN_OUT_w = {20'b0, in_i[24:13]};
//S Type Imme
    assign S_OUT_w = {{20{in_i[24]}}, in_i[24:18], in_i[4:0]};
//Shift Imme
    assign I_SHIFT_OUT_w = {27'b0, in_i[17:13]};
    
//Wire to the correct output
    always @(*) begin
        case(imm_sel_i)
            `U_TYPE: out_o = U_OUT_w;
            `J_TYPE: out_o = J_OUT_w;
            `S_TYPE: out_o = S_OUT_w;
            `B_TYPE: out_o = B_OUT_w;     
            `I_SIGNED_TYPE: out_o = I_SIGN_OUT_w;          
            `I_SHIFT_TYPE: out_o = I_SHIFT_OUT_w;         
            `I_UNSIGNED_TYPE: out_o = I_UNSIGN_OUT_w;           
            default: out_o = 0 ;                
        endcase 
    end
endmodule
