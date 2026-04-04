`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2026 10:07:31 PM
// Design Name: 
// Module Name: mux_2x1_32bit
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


module mux_2x1_32bit(out, in0, in1, sel);
    input [31:0] in0, in1;
    input sel;
    output reg [31:0] out;
    
    always @ (*) begin
        case (sel)
            1'b1: out = in1;
            default: out = in0;
        endcase
    end

endmodule