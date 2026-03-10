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




module dmem #(
    parameter DATA_WIDTH = 32,
    parameter NUM_WORDS  = 2048 // 2048 words = 8KB bộ nhớ
)(
    input  wire                  clk_i,
    input  wire                  en_i,    
    input  wire [3:0]            we_i,    
    input  wire [31:0]           addr_i,  
    input  wire [DATA_WIDTH-1:0] data_i,  
    
    output reg  [DATA_WIDTH-1:0] mem_o    
);

    reg [DATA_WIDTH-1:0] ram [0:NUM_WORDS-1];
    
    // Chuyển đổi địa chỉ Byte sang địa chỉ Word
    wire [$clog2(NUM_WORDS)-1:0] word_addr = addr_i[$clog2(NUM_WORDS)+1 : 2];

    integer i;
    initial begin
        for (i = 0; i < NUM_WORDS; i = i + 1)
            ram[i] = 32'd0;
    end

    // Khối Ghi/Đọc đồng bộ chuẩn BRAM
    always @(posedge clk_i) begin
        if (en_i) begin // BRAM chỉ hoạt động khi Enable = 1
            if (we_i[0]) ram[word_addr][ 7: 0] <= data_i[ 7: 0];
            if (we_i[1]) ram[word_addr][15: 8] <= data_i[15: 8];
            if (we_i[2]) ram[word_addr][23:16] <= data_i[23:16];
            if (we_i[3]) ram[word_addr][31:24] <= data_i[31:24];
            
            //  dữ liệu được đẩy ra ngõ ra sau 1 nhịp clock
            mem_o <= ram[word_addr]; 
        end
    end

endmodule
