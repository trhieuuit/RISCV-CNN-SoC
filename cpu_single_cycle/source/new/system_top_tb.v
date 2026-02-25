`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2026 05:03:43 PM
// Design Name: 
// Module Name: system_top_tb
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


`timescale 1ns / 1ps

module system_top_tb;

    reg clk;
    reg reset_ni;


    system_top uut (
        .clk(clk),
        .reset_ni(reset_ni)
    );
// tạo xung
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end


initial begin
        reset_ni = 0; 
        #20; 
        reset_ni = 1; 
        
        // Tăng thời gian lên 5000ns để chạy hết vòng lặp C
        #2000000; 
        
        $display("--------------------------------------------------");
        $display("KET QUA CUOI CUNG TAI RAM[5]: %d (Hy vong la 55)", uut.u_dmem.registers[5]);
        $display("===== KET THUC MO PHONG =====");
        $finish;
    end

    always @(negedge clk) begin
        if (reset_ni == 1) begin
            $display("--------------------------------------------------");
            $display("Time: %5t ns | PC: %h | Lenh: %h", $time, uut.pc_wire, uut.inst_wire);
            
            // In cac thanh ghi quan trong tu x10 den x15
            $display("   [Regs] x10(a0)=%d | x11=%d | x12=%d | x15=%h", 
                     uut.u_cpu.register_file.registers[10], 
                     uut.u_cpu.register_file.registers[11], 
                     uut.u_cpu.register_file.registers[12],
                     uut.u_cpu.register_file.registers[15]);
                     
            // In dung o nho ket qua cua C
            $display("   [Data Mem] RAM[5] = %d | RAM[4] = %d", 
                     uut.u_dmem.registers[5], 
                     uut.u_dmem.registers[4]);
        end
    
    end

endmodule