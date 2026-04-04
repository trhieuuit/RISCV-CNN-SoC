`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2026 11:31:33 AM
// Design Name: 
// Module Name: mux_4x1_32bit
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


module mux_4x1_32bit(in0, in1, in2, in3, out, sel);

    //declare the ports
    input [31:0] in0, in1, in2, in3;
    input [1:0] sel;
    output reg [31:0] out;

    //connect the relevent input to the output depending depending on the select
    // todo: add delay to mux
    // assign out = (select == 2'b11) ? in3 : (select == 2'b10) ? in2 : (select == 2'b01) ? in1 : in0;

    always @ (*) begin
        case (sel)
            2'b11: out = in3;
            2'b10: out = in2;
            2'b01: out = in1;
            default: out = in0;
        endcase
    end

endmodule
