`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Hieu
// 
// Create Date: 03/09/2026
// Design Name: RISC-V Testbench (Advanced Debug)
// Module Name: tb_riscv
// Target Devices: Vivado Simulator
// Description: Testbench có tích hợp Monitor theo dõi PC và Register File
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hieu
// Design Name: RISC-V Testbench (Advanced Debug)
// Description: Tích hợp Monitor theo dõi PC, RegFile, Hazard, Branch và Disassembler
//////////////////////////////////////////////////////////////////////////////////

module tb_riscv();

    reg clk;
    reg reset_ni;

    // ===========================================================================
    // GỌI TOP MODULE 
    // ===========================================================================
    riscv uut (
        .clk(clk),
        .reset_ni(reset_ni)
    );

    // BỘ TẠO XUNG CLOCK (100MHz)
    always #5 clk = ~clk;

    // ===========================================================================
    // BỘ GIẢI MÃ LỆNH ĐƠN GIẢN (DISASSEMBLER CHO LOG)
    // ===========================================================================
    wire [6:0] opcode = uut.rv_core.instruction[6:0];
    reg [47:0] inst_name; // Chứa tối đa 6 ký tự ASCII (8 bit * 6)

    always @(*) begin
        case(opcode)
            7'b0110111: inst_name = "LUI   ";
            7'b0010111: inst_name = "AUIPC ";
            7'b1101111: inst_name = "JAL   ";
            7'b1100111: inst_name = "JALR  ";
            7'b1100011: inst_name = "BRANCH";
            7'b0000011: inst_name = "LOAD  ";
            7'b0100011: inst_name = "STORE ";
            7'b0010011: inst_name = "ALU-I ";
            7'b0110011: inst_name = "ALU-R ";
            7'b0000000: inst_name = "BUBBLE"; // Bong bóng do Flush/Stall
            default:    inst_name = "UNKNWN";
        endcase
        // Bắt lệnh NOP (0x00000013 hoặc 0x13)
        if (uut.rv_core.instruction == 32'h00000013) inst_name = "NOP   ";
    end

    // ===========================================================================
    // KỊCH BẢN MÔ PHỎNG VÀ IN KẾT QUẢ CHUNG CUỘC
    // ===========================================================================
    integer i;
    initial begin
        clk = 0;
        reset_ni = 0; 
        
        $display("==================================================");
        $display("      BẮT ĐẦU MÔ PHỎNG SoC RISC-V (PRO MODE)      ");
        $display("==================================================");

        // Giữ Reset 4 chu kỳ
        #40;
        reset_ni = 1; 
        
        // Cho chạy tự do 3000ns để kịp test code C
        #3000; 

        // IN TOÀN BỘ THANH GHI
        $display("\n==================================================");
        $display("   TRẠNG THÁI THANH GHI (REG FILE) KHI KẾT THÚC   ");
        $display("==================================================");
        for (i = 0; i < 32; i = i + 1) begin
            $display(" x%0d \t = 32'h%h", i, uut.rv_core.register_file.registers[i]);
        end
        $display("==================================================");
        $display("                 KẾT THÚC MÔ PHỎNG                ");
        $display("==================================================");
        $finish; 
    end

    // ===========================================================================
    // ỐNG NGHE THEO DÕI THỜI GIAN THỰC (REAL-TIME MONITOR) V3.0
    // ===========================================================================
    always @(negedge clk) begin
        if (reset_ni) begin 
            
            // 1. Tầng IF: Theo dõi PC và Lệnh (Kèm tên lệnh)
            $display("Time: %0t | PC = 0x%h | Inst = 0x%h (%s)", 
                     $time, uut.rv_core.if_pc, uut.rv_core.instruction, inst_name);
            
            // 2. Tầng Pipeline Control: Theo dõi Hazard (Sửa tên wire cho khớp code của bạn)
            if (uut.rv_core.stall_pc_if_id) 
                $display("          -> [HAZARD] STALL: Phanh đường ống chờ dữ liệu Load!");
            if (uut.rv_core.flush_if_id) 
                $display("          -> [HAZARD] FLUSH: Dọn rác lệnh do nhảy (Branch/Jump)!");

            // 3. Tầng EX: Theo dõi Nhảy và Forwarding
            if (uut.rv_core.ex_branch_taken)
                $display("          -> [EX] JUMP/BRANCH TAKEN | PC chuyển hướng tới 0x%h", uut.rv_core.ex_branch_target);
                
            if (uut.rv_core.fw_sel_rs1 != 2'b00 || uut.rv_core.fw_sel_rs2 != 2'b00)
                $display("          -> [EX] FORWARDING KÍCH HOẠT | RS1_sel: %b, RS2_sel: %b", uut.rv_core.fw_sel_rs1, uut.rv_core.fw_sel_rs2);

            // 4. Tầng MEM: Theo dõi Ghi/Đọc BRAM
            if (uut.rv_core.mem_we_dmem_o) begin
                $display("          -> [MEM] WRITE RAM | Addr: 0x%h <- Data: 0x%h", 
                         uut.rv_core.mem_alu_result, uut.rv_core.mem_write_data);
            end

            if (uut.rv_core.mem_d_dmemsel_o && !uut.rv_core.mem_we_dmem_o) begin
                $display("          -> [MEM] READ RAM  | Đang yêu cầu đọc tại Addr: 0x%h", 
                         uut.rv_core.mem_alu_result);
            end
            
            // 5. Tầng WB: Theo dõi Ghi Register File
            if (uut.rv_core.wb_reg_write_en && (uut.rv_core.wb_rd != 5'd0)) begin
                if (uut.rv_core.wb_d_wbsel == 2'b01) begin // Từ RAM về
                    $display("          -> [WB]  LOAD REG  | x%0d <- 0x%h (Data RAM thô: 0x%h)", 
                             uut.rv_core.wb_rd, uut.rv_core.wb_wdata, uut.rv_core.data_rdata_i);
                end else begin // Từ ALU về
                    $display("          -> [WB]  WRITE REG | x%0d <- 0x%h", 
                             uut.rv_core.wb_rd, uut.rv_core.wb_wdata);
                end
            end
            $display("-----------------------------------------------------------------");
        end
    end

endmodule