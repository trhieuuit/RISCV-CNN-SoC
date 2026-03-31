`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Hieu
// Design Name: RISC-V Testbench (Smoke Test)
// Description: Automatically loads machine code for all basic RV32I instructions
//              to perform a functional smoke test
//////////////////////////////////////////////////////////////////////////////////

module tb_riscv_1();

    reg clk;
    reg reset_ni;

    
    // TOP MODULE INSTANTIATION
    riscv uut (
        .clk(clk),
        .reset_ni(reset_ni)
    );

    // CLOCK GENERATOR (100 MHz)
    always #5 clk = ~clk;

    // SIMPLE INSTRUCTION DECODER (DISASSEMBLER)
    wire [6:0] opcode = uut.rv_core.id_instr[6:0];
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
            7'b0000000: inst_name = "BUBBLE"; 
            default:    inst_name = "UNKNWN";
        endcase
        if (uut.rv_core.id_instr == 32'h00000013) inst_name = "NOP   ";
    end

    // ===========================================================================
    // LOAD SMOKE TEST PROGRAM INTO BRAM 'rom'
    // ===========================================================================
    integer i;
    initial begin
        clk = 0;
        reset_ni = 0; 
        
        $display("==================================================");
        $display("        STARTING RV32I SMOKE TEST SIMULATION      ");
        $display("==================================================");

        // Hold reset for 4 cycles
        #40;
        reset_ni = 1; 
        
        // Run simulation for 500ns
        #12000; 

        $display("\n==================================================");
        $display("        REGISTER FILE STATE AT SIMULATION END     ");
        $display("==================================================");
        for (i = 0; i < 14; i = i + 1) begin
            $display(" x%0d \t = 32'h%h", i, uut.rv_core.register_file.registers[i]);
        end
        $display("==================================================");
        $display("               SIMULATION FINISHED                 ");
        $display("==================================================");
        $finish; 
    end

    // ===========================================================================
    // REAL-TIME EXECUTION MONITOR
    // ===========================================================================
    always @(negedge clk) begin
        if (reset_ni) begin 
            $display("Time: %0t | PC = 0x%h | Inst = 0x%h (%s) | RS1 = %d | RS2 = %d | IMM = %d", 
                     $time, uut.rv_core.id_pc, uut.rv_core.id_instr, inst_name, uut.rv_core.ex_rs1_data, uut.rv_core.ex_rs2_data, uut.rv_core.ex_imm_in);
            
            if (uut.rv_core.stall_pc_if_id) 
                $display("          -> [HAZARD] STALL: Pipeline stalled waiting for load data");

            if (uut.rv_core.flush_id_ex) 
                $display("          -> [FLUSH]: Flushed ID/EX");

            if (uut.rv_core.flush_if_id) 
                $display("          -> [HAZARD] FLUSH: Pipeline flushed due to branch/jump");

            if (uut.rv_core.ex_branch_taken)
                $display("          -> [EX] BRANCH/JUMP TAKEN | Redirecting PC to 0x%h | BR1 = = %d | BR2 = %d", 
                          uut.rv_core.ex_branch_target, uut.rv_core.fw_data1_clean, uut.rv_core.fw_data2_clean);
                
            if (uut.rv_core.fw_sel_rs1 != 2'b00 || uut.rv_core.fw_sel_rs2 != 2'b00)
                $display("          -> [EX] FORWARDING ACTIVE | RS1_sel: %b, RS2_sel: %b  | ALU1 = %d | ALU2 = %d  " , 
                         uut.rv_core.fw_sel_rs1, uut.rv_core.fw_sel_rs2, uut.rv_core.alu_operand_a, uut.rv_core.alu_operand_b);

            if (uut.rv_core.mem_we_dmem_o) 
                $display("          -> [MEM] WRITE RAM | Addr: 0x%h <- Data: 0x%h", 
                         uut.rv_core.mem_alu_result, uut.rv_core.mem_write_data);

            if (uut.rv_core.mem_d_dmemsel_o && !uut.rv_core.mem_we_dmem_o) 
                $display("          -> [MEM] READ RAM  | Requesting read at Addr: 0x%h", 
                         uut.rv_core.mem_alu_result);
            
            if (uut.rv_core.wb_reg_write_en && (uut.rv_core.wb_rd != 5'd0)) begin
                if (uut.rv_core.wb_d_wbsel == 2'b01) begin 
                    $display("          -> [WB]  LOAD REG  | x%0d <- 0x%h (Raw RAM data: 0x%h)", 
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