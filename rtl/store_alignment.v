`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2026 12:08:33 PM
// Design Name: 
// Module Name: store_alignment
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

module store_alignment (
    input  wire [3:0]  mem_read_write_i, // Tín hiệu từ tầng MEM
    input  wire [1:0]  addr_offset, 
    input  wire [31:0] rs2_data_i,  
    
    output reg  [31:0] aligned_data_o, 
    output reg  [3:0]  byte_enable_o   
);

    always @(*) begin
        aligned_data_o = rs2_data_i;
        byte_enable_o  = 4'b0000;

        case (mem_read_write_i)
            `SB: begin 
                aligned_data_o = {4{rs2_data_i[7:0]}}; 
                case (addr_offset)
                    2'b00: byte_enable_o = 4'b0001;
                    2'b01: byte_enable_o = 4'b0010;
                    2'b10: byte_enable_o = 4'b0100;
                    2'b11: byte_enable_o = 4'b1000;
                endcase
            end
            `SH: begin 
                aligned_data_o = {2{rs2_data_i[15:0]}}; 
                case (addr_offset[1]) 
                    1'b0: byte_enable_o = 4'b0011; 
                    1'b1: byte_enable_o = 4'b1100; 
                endcase
            end
            `SW: begin 
                aligned_data_o = rs2_data_i;
                byte_enable_o  = 4'b1111; 
            end
            default: byte_enable_o = 4'b0000;
        endcase
    end
endmodule