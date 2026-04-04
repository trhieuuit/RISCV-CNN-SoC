`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: DMEM
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
//                  Instruction Memory                      //
//==========================================================//

module imem#(
    parameter DATA_WIDTH = 32,
    parameter NUM_INS = 1000
)(
    input  wire        clk_i,
    input  wire        en_i,    
    input  wire [31:0] addr_i,  
    input  wire        rst_ni,
    output reg  [31:0] imem_o  
);

// Memory declaration
    reg [DATA_WIDTH-1:0] rom_r [0:NUM_INS-1];

// Read from machine code memory file 
    integer i;
    initial begin
       for (i = 0; i < NUM_INS; i = i + 1) begin
            rom_r[i] = 32'h0;
       end
    
 // !!! Comment this line if yorue loading machine code in test bench module !!! 
 // !!! Remember to paste the machine code in machine_code.mem !!!
       $readmemh("machine_code.mem",  rom_r);
       
    end
    
// Read from the memory
        always @(posedge clk_i) begin
        if (!rst_ni) begin
            imem_o <= 32'h00000013; // Force to NOP if reset
        end else if (en_i) begin
            imem_o <=  rom_r[addr_i[31:2]]; 
        end
    end

endmodule