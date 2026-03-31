`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2026 08:27:41 PM
// Design Name: 
// Module Name: hazard_detection_unit
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


module hazard_detection_unit (
    input  wire [4:0] id_rs1, 
    input  wire [4:0] id_rs2,
    input  wire [4:0] ex_rd,
    input  wire       ex_is_load,
    input  wire       ex_branch_taken,
    
    // 3 lệnh điều khiển
    output reg        stall_pc_if_id,
    output reg        flush_if_id,
    output reg        flush_id_ex
);

    always @(*) begin
        // Mặc định
        stall_pc_if_id = 1'b0;
        flush_if_id    = 1'b0;
        flush_id_ex    = 1'b0;

        // Ưu tiên 1: Xử lý nhảy (Branch/Jump)
        if (ex_branch_taken) begin
            flush_if_id = 1'b1; 
            flush_id_ex = 1'b1; 
        end
        
        // ƯU TIÊN 2: Xử lý kẹt dữ liệu do lệnh Load (Load-Use Hazard)
        else if (ex_is_load && (ex_rd != 5'd0) && ((ex_rd == id_rs1) || (ex_rd == id_rs2))) begin
            stall_pc_if_id = 1'b1; // giữ nguyên lệnh ở IF/ID và PC
            flush_id_ex    = 1'b1; //(NOP) vào tầng EX 
        end
    end
    
endmodule
