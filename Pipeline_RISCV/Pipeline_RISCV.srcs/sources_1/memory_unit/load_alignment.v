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

//==========================================================//
//                     Load Alignment                       //
//==========================================================//

module load_alignment (
    input  wire [3:0]  wb_read_write_i, 
    input  wire [1:0]  addr_offset_i,
    input  wire [31:0] mem_data_i,
    
    output reg  [31:0] wb_data_o
);

// Byte/Half word result declaration
    reg [7:0]  byte_data_r;
    reg [15:0] half_data_r;

    always @(*) begin
        // Get byte/half word result
        case (addr_offset_i)
            2'b00: begin byte_data_r = mem_data_i[7:0];   half_data_r = mem_data_i[15:0];  end
            2'b01: begin byte_data_r = mem_data_i[15:8];  half_data_r = 16'b0; end
            2'b10: begin byte_data_r = mem_data_i[23:16]; half_data_r = mem_data_i[31:16]; end
            2'b11: begin byte_data_r = mem_data_i[31:24]; half_data_r = 16'b0; end
        endcase

        // Sign extension and get final result
        case (wb_read_write_i)
            `LB:  wb_data_o = {{24{byte_data_r[7]}}, byte_data_r};
            `LH:  wb_data_o = {{16{half_data_r[15]}}, half_data_r};
            `LW:  wb_data_o = mem_data_i;
            `LBU: wb_data_o = {24'b0, byte_data_r};
            `LHU: wb_data_o = {16'b0, half_data_r};
            default: wb_data_o = mem_data_i; 
        endcase
    end
endmodule
