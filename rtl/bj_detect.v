`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2026 10:32:06 PM
// Design Name: 
// Module Name: bj_detect
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



module bj_detect(
    input  wire [2:0]  branch_jump_i,
    input  wire [31:0] data1_i,
    input  wire [31:0] data2_i,
    output reg         pc_sel_o
);

    // Tính toán các cờ so sánh
    wire eq          = (data1_i == data2_i);
    wire unsigned_lt = (data1_i < data2_i);
    wire signed_lt   = ($signed(data1_i) < $signed(data2_i));

    always @(*) begin
        pc_sel_o = 1'b0; 

        case (branch_jump_i)
           `BEQ: if (eq)          pc_sel_o = 1'b1; // (BEQ)
           `BNE: if (!eq)         pc_sel_o = 1'b1; // (BNE)
           `J:                  pc_sel_o = 1'b1; // (JAL/JALR)
            
            // Xử lý các lệnh nhỏ hơn (<)
            `BLT: if (signed_lt)   pc_sel_o = 1'b1; // Tương đương out3 (BLT)
            `BLTU: if (unsigned_lt) pc_sel_o = 1'b1; // (BLTU)
            
            // Xử lý các lệnh lớn hơn hoặc bằng (>=)
           `BGE: if (!signed_lt)  pc_sel_o = 1'b1; // Tương đương out5 (BGE)
            `BGEU: if (!unsigned_lt)pc_sel_o = 1'b1; // (BGEU)
            
            default: pc_sel_o = 1'b0;
        endcase
    end


endmodule
