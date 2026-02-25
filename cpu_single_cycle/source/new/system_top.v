`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2026 11:02:27 PM
// Design Name: 
// Module Name: system_top
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



module system_top(
    input wire clk,
    input wire reset_ni
);

//Bus
    
    // Dây nối Instruction Memory
    wire [31:0] pc_wire;         
    wire [31:0] inst_wire;       

    // Dây nối Data Memory
    wire [31:0] data_addr_wire;  
    wire [31:0] data_wdata_wire; 
    wire [31:0] data_rdata_wire; 
    wire [3:0]  data_ctrl_wire;  

    // chia cho 4
    wire [4:0] dmem_addr_wire = data_addr_wire[6:2]; 

    //  giải mã cờ Write Enable từ mã 4-bit của encoding.v

    wire dmem_we_wire = (data_ctrl_wire == 4'b1011) | 
                        (data_ctrl_wire == 4'b1110) | 
                        (data_ctrl_wire == 4'b1111);

   // CPU
    cpu_single_cycle u_cpu (
        .clk              (clk),
        .reset_ni         (reset_ni),
        .inst_addr_o      (pc_wire),
        .instruction    (inst_wire),
        .data_addr_o      (data_addr_wire),
        .data_wdata_o     (data_wdata_wire),
        .data_rdata_i     (data_rdata_wire),
        .data_mem_ctrl_o  (data_ctrl_wire)  
    );

   
    // INSTRUCTION MEMORY

    imem #(
        .DATA_WIDTH(32),
        .NUM_INS(1000)
    ) u_imem (
        .clk_i      (clk),
        .rst_ni     (reset_ni),
        .addr_i     (pc_wire),       
        .imem_o     (inst_wire)      
    );

    // =======================================================
    // DATA MEMORY CỦA BẠN VÀO
    // =======================================================
    dmem #(
        .DATA_WIDTH(32),
        .NUM_VAR(32),
        .ADDR_WIDTH(5)
    ) u_dmem (
        .clk_i      (clk),
        .rst_ni     (reset_ni),
        .addr_i     (dmem_addr_wire),  // Đưa địa chỉ 5-bit vào
        .data_i     (data_wdata_wire), // Dữ liệu cần ghi
        .we_i       (dmem_we_wire),    // Cờ Write (1-bit) đã được giải mã
        .mem_o      (data_rdata_wire)  // Dữ liệu đọc ra
    );

endmodule