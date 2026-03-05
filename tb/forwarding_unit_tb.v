`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2026 06:06:11 PM
// Design Name: 
// Module Name: forwarding_unit_tb
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

`include "encoding.v"

module forwarding_unit_tb;

//////// INPUTS ////////
reg [4:0]  ex_rs1_addr;
reg [4:0]  ex_rs2_addr;
reg [31:0] ex_rs1_data;
reg [31:0] ex_rs2_data;
reg [6:0]  ex_opcode;

reg [4:0]  mem_rd_addr;
reg [31:0] mem_rd_data;
reg [6:0]  mem_opcode;

reg [4:0]  wb_rd_addr;
reg [31:0] wb_rd_data;
reg [6:0]  wb_opcode;

//////// OUTPUTS ////////
wire [31:0] ex_data1;
wire [31:0] ex_data2;

//////// DUT ////////
forwarding_unit dut(
    .ex_rs1_addr(ex_rs1_addr),
    .ex_rs2_addr(ex_rs2_addr),
    .ex_rs1_data(ex_rs1_data),
    .ex_rs2_data(ex_rs2_data),
    .ex_opcode(ex_opcode),

    .mem_rd_addr(mem_rd_addr),
    .mem_rd_data(mem_rd_data),
    .mem_opcode(mem_opcode),

    .wb_rd_addr(wb_rd_addr),
    .wb_rd_data(wb_rd_data),
    .wb_opcode(wb_opcode),

    .ex_data1(ex_data1),
    .ex_data2(ex_data2)
);

initial begin

////////////////////////////////////////////////////////
$display("TEST 1: No forwarding");
////////////////////////////////////////////////////////

ex_rs1_addr = 5'd1;
ex_rs2_addr = 5'd2;
ex_rs1_data = 32'hAAAA1111;
ex_rs2_data = 32'hBBBB2222;
ex_opcode   = `R_TYPE_OPCODE;

mem_rd_addr = 5'd3;
mem_rd_data = 32'h12345678;
mem_opcode  = `R_TYPE_OPCODE;

wb_rd_addr  = 5'd4;
wb_rd_data  = 32'h87654321;
wb_opcode   = `R_TYPE_OPCODE;

#10;


////////////////////////////////////////////////////////
$display("TEST 2: Forward from MEM stage");
////////////////////////////////////////////////////////

ex_rs1_addr = 5'd3;
ex_rs2_addr = 5'd2;

mem_rd_addr = 5'd3;
mem_rd_data = 32'hDEADBEEF;
mem_opcode  = `R_TYPE_OPCODE;

#10;


////////////////////////////////////////////////////////
$display("TEST 3: Forward from WB stage");
////////////////////////////////////////////////////////

ex_rs1_addr = 5'd4;
ex_rs2_addr = 5'd2;

mem_rd_addr = 5'd6;

wb_rd_addr  = 5'd4;
wb_rd_data  = 32'hCAFEBABE;
wb_opcode   = `R_TYPE_OPCODE;

#10;


////////////////////////////////////////////////////////
$display("TEST 4: MEM priority over WB");
////////////////////////////////////////////////////////

ex_rs1_addr = 5'd5;

mem_rd_addr = 5'd5;
mem_rd_data = 32'h11111111;

wb_rd_addr  = 5'd5;
wb_rd_data  = 32'h22222222;

#10;


////////////////////////////////////////////////////////
$display("TEST 5: x0 should never forward");
////////////////////////////////////////////////////////

ex_rs1_addr = 5'd0;

mem_rd_addr = 5'd0;
mem_rd_data = 32'hFFFFFFFF;

wb_rd_addr  = 5'd0;
wb_rd_data  = 32'hEEEEEEEE;

#10;

$finish;

end

endmodule
