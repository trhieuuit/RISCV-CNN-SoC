`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2026 09:21:42 PM
// Design Name: 
// Module Name: load_alignment
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

module load_alignment (
    input  wire [3:0]  wb_read_write_i, 
    input  wire [1:0]  addr_offset,
    input  wire [31:0] mem_data_i,
    
    output reg  [31:0] wb_data_o
);

    reg [7:0]  byte_data;
    reg [15:0] half_data;

    always @(*) begin
        // Bước 1: Chọn byte/half-word 
        case (addr_offset)
            2'b00: begin byte_data = mem_data_i[7:0];   half_data = mem_data_i[15:0];  end
            2'b01: begin byte_data = mem_data_i[15:8];  half_data = 16'b0; end
            2'b10: begin byte_data = mem_data_i[23:16]; half_data = mem_data_i[31:16]; end
            2'b11: begin byte_data = mem_data_i[31:24]; half_data = 16'b0; end
        endcase

        // Bước 2: Mở rộng dấu dựa trên Macro 
        case (wb_read_write_i)
            `LB:  wb_data_o = {{24{byte_data[7]}}, byte_data};
            `LH:  wb_data_o = {{16{half_data[15]}}, half_data};
            `LW:  wb_data_o = mem_data_i;
            `LBU: wb_data_o = {24'b0, byte_data};
            `LHU: wb_data_o = {16'b0, half_data};
            default: wb_data_o = mem_data_i; 
        endcase
    end
endmodule
