`timescale 1ns / 1ps
//==========================================================//
//                   Branch Jump Unit                       //
//==========================================================//	
`include "encoding.v"
module bj_detect(
    input  wire [2:0]   op_i,
    input  wire [31:0]  data1_i,
    input  wire [31:0]  data2_i,
    input  wire         is_jalr_i,
    input  wire [31:0]  pc_i,
    input  wire [31:0]  imm_i,
    output reg          b_taken_o,
    output wire  [31:0] b_target_o

);
    //Branch target calculation
    assign b_target_o = is_jalr_i ? (data1_i + imm_i) : (pc_i + imm_i);

    //Branch detection
    // Comparison flag calculation
    wire [31:0] sub_res = data1_i - data2_i;
    wire sign_diff = data1_i[31] ^ data2_i[31];
    wire eq_w = ~(|(data1_i ^ data2_i));
    wire signed_lt_w = sign_diff ? data1_i[31] : sub_res[31];
    wire unsigned_lt_w = sign_diff ? data2_i[31] : sub_res[31];
	
    // Output the signal to control PC's MUX (whether to jump or increase by 4)
    always @(*) begin
        b_taken_o = 1'b0; 
        case (op_i)
           `BEQ: if (eq_w)          b_taken_o = 1'b1; // (BEQ)
           `BNE: if (!eq_w)         b_taken_o = 1'b1; // (BNE)
           `J:                      b_taken_o = 1'b1; // (JAL/JALR)
            
            // "Less than" instructions
            `BLT: if (signed_lt_w)      b_taken_o = 1'b1; // (BLT)
            `BLTU: if (unsigned_lt_w)   b_taken_o = 1'b1; // (BLTU)
            
           // "Greater than" and "equal" instructions
           `BGE: if (!signed_lt_w)      b_taken_o = 1'b1; // (BGE)
            `BGEU: if (!unsigned_lt_w)  b_taken_o = 1'b1; // (BGEU)
            
            default: b_taken_o = 1'b0;
        endcase
    end


endmodule
