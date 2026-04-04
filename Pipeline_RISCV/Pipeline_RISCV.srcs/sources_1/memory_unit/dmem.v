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
//                     Data Memory                          //
//==========================================================//	

module dmem #(
    parameter DATA_WIDTH = 32,
    parameter NUM_WORDS  = 2048
)(
    input  wire                  clk_i,
    input  wire                  en_i,    
    input  wire [3:0]            we_i,    
    input  wire [31:0]           addr_i,  
    input  wire [DATA_WIDTH-1:0] data_i,  
    
    output reg  [DATA_WIDTH-1:0] mem_o    
);

// Memory declaration
    reg [DATA_WIDTH-1:0] ram_r [0:NUM_WORDS-1];
// Address calculation
    wire [$clog2(NUM_WORDS)-1:0] word_addr_w = addr_i[$clog2(NUM_WORDS)+1 : 2];
    
// Set memory initial value
    integer i;
    initial begin
        for (i = 0; i < NUM_WORDS; i = i + 1)
            ram_r[i] = 32'd0;
// !!! Uncomment this line if you need to load in DMEM (when testing with riscv-test) !!!
       //$readmemh("data.mem",  ram_r);
    end

//==========================================================//
//                     Write/Read Port                      //
//==========================================================//
// Byte addressible memory
    always @(posedge clk_i) begin
        if (en_i) begin 
            if (we_i[0]) ram_r[word_addr_w][ 7: 0] <= data_i[7:0];
            if (we_i[1]) ram_r[word_addr_w][15: 8] <= data_i[15: 8];
            if (we_i[2]) ram_r[word_addr_w][23:16] <= data_i[23:16];
            if (we_i[3]) ram_r[word_addr_w][31:24] <= data_i[31:24];
            mem_o <= ram_r[word_addr_w]; 
        end
    end

endmodule
