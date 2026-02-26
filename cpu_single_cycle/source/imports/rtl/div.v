`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 05:10:17 PM
// Design Name: 
// Module Name: unsigned_div
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


module div(
    input  wire        clk_i,
    input  wire        rst_n,
    input  wire        start_i,
    input  wire        is_signed_i,
    input  wire [31:0] rs1_i,
    input  wire [31:0] rs2_i,

    output wire [31:0] quotient_o,
    output wire [31:0] remainder_o,
    output wire        done_o
    );
    
    wire rs1_sign = rs1_i[31];
    wire rs2_sign = rs2_i[31];
    
    // rs1 -> dividend
    // rs2 -> divisor
    wire [31:0] dividend_abs = (is_signed_i && rs1_sign) ? (~rs1_i + 1) : rs1_i;
    wire [31:0] divisor_abs =  (is_signed_i && rs2_sign) ? (~rs2_i + 1) : rs2_i;
    
    wire [31:0] quotient_unsigned;
    wire [31:0] remainder_unsigned;
    
    unsigned_div u_unsigned_div(
        .clk_i(clk_i),
        .rst_n(rst_n),
        .start_i(start_i),
        .dividend_i(dividend_abs),
        .divisor_i(divisor_abs),
        .quotient_o(quotient_unsigned),
        .remainder_o(remainder_unsigned),
        .done_o(done_o)
    );
    wire div_by_zero = (rs2_i == 32'b0);
    
    assign quotient_o = div_by_zero ? 32'hFFFFFFFF : (is_signed_i && (rs1_sign ^ rs2_sign)) ? (~quotient_unsigned + 1) : quotient_unsigned;
    assign remainder_o = (is_signed_i && rs1_sign) ? (~remainder_unsigned + 1) : remainder_unsigned;
    
    
        
endmodule

 
