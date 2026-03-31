`timescale 1ns / 1ps

module tb_riscv();

    reg clk;
    reg reset_ni;
    wire rv_done_o;

    // ===========================================================================
    // GỌI TOP MODULE 
    // ===========================================================================
    riscv uut (
        .clk(clk),
        .reset_ni(reset_ni),
        .rv_done_o(rv_done_o)
    );

    // BỘ TẠO XUNG CLOCK (100MHz)
    always #5 clk = ~clk;

    // ===========================================================================
    // BỘ GIẢI MÃ LỆNH ĐƠN GIẢN (DISASSEMBLER CHO LOG)
    // ===========================================================================
    wire [6:0] opcode = uut.rv_core.instruction[6:0];
    reg [47:0] inst_name; 

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
            7'b1110011: inst_name = "ECALL "; 
            7'b0000000: inst_name = "BUBBLE"; 
            default:    inst_name = "UNKNWN";
        endcase
        if (uut.rv_core.id_instr == 32'h00000013) inst_name = "NOP   ";
    end

    // ===========================================================================
    // KỊCH BẢN MÔ PHỎNG VÀ IN KẾT QUẢ CHUNG CUỘC
    // ===========================================================================
    integer i;
    integer timeout_counter; // Bộ đếm thời gian timeout
    
    initial begin
        clk = 0;
        reset_ni = 0; 
        timeout_counter = 0;
        
        $display("==================================================");
        $display("      BẮT ĐẦU MÔ PHỎNG SoC RISC-V (PRO MODE)      ");
        $display("==================================================");

        // NẠP LỆNH TRỰC TIẾP VÀO IMEM
        uut.instruction_memory.rom[0] = 32'h00500093;  // addi x1, x0, 5 
        uut.instruction_memory.rom[1] = 32'h00a00113;  // addi x2, x0, 10
        uut.instruction_memory.rom[2] = 32'h002081b3;  // add  x3, x1, x2
        uut.instruction_memory.rom[3] = 32'h00000073;  // ecall          
        
        uut.instruction_memory.rom[4] = 32'h00000013;  // NOP
        uut.instruction_memory.rom[5] = 32'h00000013;  // NOP

        // Giữ Reset 4 chu kỳ
        #42;
        reset_ni = 1; 
        
        // CHỜ TÍN HIỆU DONE HOẶC TIMEOUT (Sử dụng lệnh cơ bản)
        // Lặp lại việc chờ 5ns cho đến khi cpu_halted = 1 hoặc đạt 2000 lần (10000ns)
        while ((uut.rv_core.cpu_halted == 1'b0) && (timeout_counter < 2000)) begin
            #5;
            timeout_counter = timeout_counter + 1;
        end

        // Kiểm tra xem vòng lặp kết thúc vì lý do gì
        if (uut.rv_core.cpu_halted == 1'b1) begin
            #20; // Chờ thêm một chút để in nốt log cuối
            $display("\n[SUCCESS] Tín hiệu DONE (ECALL) đã được kích hoạt thành công!");
        end else begin
            $display("\n[TIMEOUT] Lỗi: Không thấy ECALL sau 10000ns!");
        end

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
            
            $display("Time: %0t | PC = 0x%h | Inst = 0x%h (%s)", 
                     $time, uut.rv_core.id_pc, uut.rv_core.id_instr, inst_name);
            
            if (uut.rv_core.cpu_halted) begin
                $display("          -> [SYSTEM] CPU HALTED: Đã bắt được ECALL, CPU đang đóng băng!");
            end

            if (uut.rv_core.stall_pc_if_id) 
                $display("          -> [HAZARD] STALL: Phanh đường ống chờ dữ liệu Load!");
            if (uut.rv_core.flush_if_id) 
                $display("          -> [HAZARD] FLUSH: Dọn rác lệnh do nhảy (Branch/Jump)!");

            if (uut.rv_core.ex_branch_taken)
                $display("          -> [EX] JUMP/BRANCH TAKEN | PC chuyển hướng tới 0x%h", uut.rv_core.ex_branch_target);
                
            if (uut.rv_core.fw_sel_rs1 != 2'b00 || uut.rv_core.fw_sel_rs2 != 2'b00)
                $display("          -> [EX] FORWARDING KÍCH HOẠT | RS1_sel: %b, RS2_sel: %b", uut.rv_core.fw_sel_rs1, uut.rv_core.fw_sel_rs2);

            if (uut.rv_core.mem_we_dmem_o) begin
                $display("          -> [MEM] WRITE RAM | Addr: 0x%h <- Data: 0x%h", 
                         uut.rv_core.mem_alu_result, uut.rv_core.mem_write_data);
            end

            if (uut.rv_core.mem_d_dmemsel_o && !uut.rv_core.mem_we_dmem_o) begin
                $display("          -> [MEM] READ RAM  | Đang yêu cầu đọc tại Addr: 0x%h", 
                         uut.rv_core.mem_alu_result);
            end
            
            if (uut.rv_core.wb_reg_write_en && (uut.rv_core.wb_rd != 5'd0)) begin
                if (uut.rv_core.wb_d_wbsel == 2'b01) begin 
                    $display("          -> [WB]  LOAD REG  | x%0d <- 0x%h (Data RAM thô: 0x%h)", 
                             uut.rv_core.wb_rd, uut.rv_core.wb_wdata, uut.rv_core.data_rdata_i);
                end else begin 
                    $display("          -> [WB]  WRITE REG | x%0d <- 0x%h", 
                             uut.rv_core.wb_rd, uut.rv_core.wb_wdata);
                end
            end
            $display("-----------------------------------------------------------------");
        end
    end

endmodule