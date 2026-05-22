`timescale 1ns / 1ps

module mux_4x1_32bit(in0, in1, in2, in3, out, sel);

    //declare the ports
    input [31:0] in0, in1, in2, in3;
    input [1:0] sel;
    output reg [31:0] out;

    always @ (*) begin
        case (sel)
            2'b11: out = in3;
            2'b10: out = in2;
            2'b01: out = in1;
            default: out = in0;
        endcase
    end

endmodule
