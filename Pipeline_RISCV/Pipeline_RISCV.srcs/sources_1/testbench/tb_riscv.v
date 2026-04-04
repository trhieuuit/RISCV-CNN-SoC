`timescale 1ns / 1ps

module tb_riscv();
//==========================================================//
//              RISC-V Simulation Test Bench                //
//==========================================================//
// Global signals
    reg  clk_i;
    reg  reset_ni;
    wire done_o;
    
    always #5 clk_i = ~clk_i;
    
    riscv uut (
        .clk_i    (clk_i),
        .reset_ni (reset_ni),
        .rv_done_o(done_o)
    );

//=====================================================================//
//                       Get Instruction Type                          //
//=====================================================================//
    wire [6:0] opcode_w = uut.rv_core.id_instr_w[6:0];
    reg [47:0] inst_name_r; 
    always @(*) begin
        case(opcode_w)
            7'b0110111: inst_name_r = "LUI   ";
            7'b0010111: inst_name_r = "AUIPC ";
            7'b1101111: inst_name_r = "JAL   ";
            7'b1100111: inst_name_r = "JALR  ";
            7'b1100011: inst_name_r = "BRANCH";
            7'b0000011: inst_name_r = "LOAD  ";
            7'b0100011: inst_name_r = "STORE ";
            7'b0010011: inst_name_r = "ALU-I ";
            7'b0110011: inst_name_r = "ALU-R ";
            7'b1110011: inst_name_r = "ECALL "; 
            7'b0000000: inst_name_r = "BUBBLE"; 
            default:    inst_name_r = "UNKNWN";
        endcase
        if (uut.rv_core.id_instr_w == 32'h00000013) inst_name_r = "NOP   ";
    end

    // ===========================================================================
    // SIMULATION SCRIPT & FINAL RESULT DUMP
    // ===========================================================================
    
    // Timeout counter to prevent infinite loops
    integer i;
    integer timeout_counter; 

    initial begin
        clk_i = 0;
        reset_ni = 0; 
        timeout_counter = 0;
        
        $display("==================================================");
        $display("      STARTING PIPELINE CPU SIMULATION            ");
        $display("==================================================");

//====================================================================//
// Either load instructions directly into IMEM,                       //
// or uncomment "readmem" in IMEM nmodule                             //
//====================================================================//
        #5
        /*uut.instruction_memory.rom_r[0] = 32'h00500093;  // addi x1, x0, 5 
        uut.instruction_memory.rom_r[1] = 32'h00a00113;  // addi x2, x0, 10
        uut.instruction_memory.rom_r[2] = 32'h002081b3;  // add  x3, x1, x2
        uut.instruction_memory.rom_r[3] = 32'h00000073;  // ecall          
        uut.instruction_memory.rom_r[4] = 32'h00000013;  // NOP
        uut.instruction_memory.rom_r[5] = 32'h00000013;  // NOP*/

        // Hold Reset for 4 cycles
        #42;
        reset_ni = 1; 
        
        // Wait for Done or Timeout
        while ((uut.rv_core.done_o == 1'b0) && (timeout_counter < 2000)) begin
            #5;
            timeout_counter = timeout_counter + 1;
        end

        if (uut.rv_core.done_o == 1'b1) begin
            #20; 
            $display("\n[SYSTEM] Finished: DONE signal triggered successfully!");
        end else begin
            $display("\n[SYSTEM] Error: ECALL not found after 10000ns!");
        end

//=====================================================================//
//                       Display Register File                         //
//=====================================================================//
        $display("\n==================================================");
        $display("         REGISTER FILE STATE AT FINISH            ");
        $display("==================================================");
        for (i = 0; i < 32; i = i + 1) begin
            $display(" x%0d \t = 32'h%h", i, uut.rv_core.register_file.registers_r[i]); 
        end
       
        $display("==================================================");
        $display("                 SIMULATION ENDED                 ");
        $display("==================================================");
        $finish; 
    end

//=====================================================================//
//                    Real-time Pipeline Tracer                        //
//=====================================================================//
    always @(negedge clk_i) begin
        if (reset_ni) begin 
            
            $display("Time: %0t | PC = 0x%h | Inst = 0x%h (%s)", 
                     $time, uut.rv_core.id_pc_data_w, uut.rv_core.id_instr_w, inst_name_r);
            
            if (uut.rv_core.done_o) begin
                $display("          -> [SYSTEM] FINISH: ECALL caught, CPU is freezing!");
            end

            if (uut.rv_core.stall_pc_if_id_w) 
                $display("          -> [HAZARD] STALL: Pipeline stalled waiting for Load data!");
            if (uut.rv_core.flush_if_id_w) 
                $display("          -> [HAZARD] FLUSH: Clearing pipeline instructions due to Branch/Jump!");

            if (uut.rv_core.ex_branch_taken_w)
                $display("          -> [EX] JUMP/BRANCH TAKEN | PC redirected to 0x%h", uut.rv_core.ex_branch_target_w);
                
            if (uut.rv_core.fw_sel_rs1_w != 2'b00 || uut.rv_core.fw_sel_rs2_w != 2'b00)
                $display("          -> [EX] FORWARDING ACTIVATED | RS1_sel: %b, RS2_sel: %b", uut.rv_core.fw_sel_rs1_w, uut.rv_core.fw_sel_rs2_w);

            if (uut.rv_core.mem_we_dmem_w) begin
                $display("          -> [MEM] WRITE RAM | Addr: 0x%h <- Data: 0x%h", 
                         uut.rv_core.mem_alu_result_w, uut.rv_core.mem_write_data_w);
            end

            if (uut.rv_core.mem_d_dmemsel_w && !uut.rv_core.mem_we_dmem_w) begin
                $display("          -> [MEM] READ RAM  | Read requested at Addr: 0x%h", 
                         uut.rv_core.mem_alu_result_w);
            end
            
            if (uut.rv_core.wb_reg_write_en_w && (uut.rv_core.wb_rd_w != 5'd0)) begin
                if (uut.rv_core.wb_d_wbsel_w == 2'b01) begin 
                    $display("          -> [WB]  LOAD REG  | x%0d <- 0x%h (Raw RAM Data: 0x%h)", 
                             uut.rv_core.wb_rd_w, uut.rv_core.wb_wdata_w, uut.rv_core.data_rdata_i);
                end else begin 
                    $display("          -> [WB]  WRITE REG | x%0d <- 0x%h", 
                             uut.rv_core.wb_rd_w, uut.rv_core.wb_wdata_w);
                end
            end
            $display("-----------------------------------------------------------------");
        end
    end

endmodule