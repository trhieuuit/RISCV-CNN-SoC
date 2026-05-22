`timescale 1ns / 1ps
//==========================================================//
//                    RISC-V Wrapper                        //
//==========================================================//
//This module includes RISC-V main components except IMEM and DMEM 

module cpu_pipeline(
    // Global Ports
    input  wire        clk_i,
    input  wire        reset_ni,
    output wire        done_o,
    
    // IMEM Ports (IF stage)
    input  wire [31:0] instr_i,      // BRAM read data
    output wire [31:0] instr_addr_o, // BRAM address
    output wire        instr_en_o,   // BRAM enable
    
    // DMEM Ports (MEM stage)
    input  wire [31:0] data_rdata_i, // BRAM read data
    output wire [31:0] data_addr_o,  // BRAM address
    output wire [31:0] data_wdata_o, // BRAM write data  
    output wire        data_en_o,    // BRAM enable
    output wire [3:0]  data_we_o     // BRAM write enable
);

//==========================================================//
//                 Register Declaration                     //
//==========================================================//
    reg id_done_r;
    reg flush_delay_r;
    
//==========================================================//
//                   Wire Declaration                       //
//==========================================================//
    // Pipeline registers stall/flush wires
    wire stall_pc_if_id_w; 
    wire flush_if_id_w;
    wire flush_id_ex_w;

    // IF wires
    wire [31:0] if_pc_next_w;
    wire [31:0] if_pc_plus_4_w;  
    wire [31:0] if_pc_w;
    
    // ID wires
    wire [31:0] id_pc_w;            
    wire [31:0] id_instr_w;        
    wire [31:0] id_rs1_data_w;
    wire [31:0] id_rs2_data_w;
    wire [31:0] id_imm_w;
    wire        id_op1sel_w;
    wire        id_op2sel_w;
    wire        id_reg_write_en_w;
    wire [1:0]  id_wb_sel_w;
    wire [4:0]  id_alu_op_w;
    wire [2:0]  id_bju_op_w;
    wire [2:0]  id_imm_sel_w;
    wire [3:0]  id_read_write_w;
    wire [1:0]  id_d1_bjsel_w, id_d2_bjsel_w;
    wire        id_is_load_w;
    wire        id_we_dmem_w;
    wire        id_is_jalr_w;
    wire        id_done_w;
    wire [4:0]  id_clean_rs1_addr_w;

    // EX wires
    wire [31:0] ex_pc_in_w;
    wire [4:0]  ex_rd_in_w;
    wire [4:0]  ex_rs1_addr_w;     
    wire [4:0]  ex_rs2_addr_w;     
    wire [31:0] ex_rs1_data_w;
    wire [31:0] ex_rs2_data_w;
    wire [31:0] ex_imm_in_w;
    wire [31:0] ex_alu_operand_a_w;
    wire [31:0] ex_alu_operand_b_w;
    wire [31:0] ex_alu_res_w;
    wire [1:0]  ex_d1_alusel_w;
    wire [1:0]  ex_d2_alusel_w;
    wire [1:0]  ex_d1_bjsel_w;
    wire [1:0]  ex_d2_bjsel_w;
    wire [4:0]  ex_op_alu_w;
    wire [2:0]  ex_op_bl_w;
    wire        ex_is_jalr_w;
    wire        ex_is_load_w;
    wire        ex_we_dmem_w;
    wire [3:0]  ex_rw_dmem_w;
    wire [1:0]  ex_wb_sel_w;
    wire        ex_reg_we_w;
    wire [31:0] ex_branch_target_w;
    wire        ex_branch_taken_w;
    wire        ex_done_w;
    
    // MEM wires
    wire [4:0]  mem_rd_in_w;
    wire [31:0] mem_alu_res_w;
    wire [31:0] mem_write_data_w;
    wire        mem_we_dmem_w;
    wire [3:0]  mem_rw_dmem_w;
    wire [1:0]  mem_wb_sel_w;
    wire        mem_reg_we_w;
    wire [31:0] mem_pc_w;  
    wire [31:0] mem_imm_w;
    wire [3:0]  mem_aligned_byte_en_w;
    wire        mem_done_w;
    
    // WB wires
    wire        wb_reg_write_en_w; 
    wire [4:0]  wb_rd_addr_w;            
    wire [31:0] wb_wdata_w;
    wire [31:0] wb_pc_out_w;
    wire [31:0] wb_alu_res_w;
    wire [31:0] wb_imm_out_w;
    wire [1:0]  wb_sel_w;
    wire [3:0]  wb_read_write;
    wire        wb_done_w;
    wire [31:0] wb_load_data_w; 
    
    // Forwarding Unit wires
    wire [1:0]  fw_sel_rs1_w;
    wire [1:0]  fw_sel_rs2_w;
    wire [31:0] fw_data1_w;
    wire [31:0] fw_data2_w;        

//==========================================================//
//                       IF stage                           //
//==========================================================//
    // Assign BRAM input port 
    assign instr_addr_o = if_pc_w;
    
    // Freeze IMEM output during a Hazard Stall
    assign instr_en_o = ~stall_pc_if_id_w;
    
    // PC = PC + 4
    assign if_pc_plus_4_w = if_pc_w + 32'd4;
    
    // Get the next value for PC
    assign if_pc_next_w = (!reset_ni) ? 32'h00000000 : 
                          (id_done_r) ? if_pc_w :       
                          (ex_branch_taken_w) ? ex_branch_target_w : 
                          if_pc_plus_4_w;
                      
    pc program_counter (
        .clk_i     (clk_i),
        .rst_ni    (reset_ni),
        .stall_i   (stall_pc_if_id_w),  // Stall signal from Hazard Detection Unit
        .pc_next_i (if_pc_next_w),
        .pc_o      (if_pc_w)            
    );
    
//==========================================================//
//                IF/ID Pipeline Register                   //
//==========================================================//    
    if_id_reg if_id_pipeline_reg (
        .clk_i   (clk_i), 
        .rst_ni  (reset_ni),
        .stall_i (stall_pc_if_id_w), // Stall signal from Hazard Detection Unit
        .pc_i    (if_pc_w),   
        .pc_o    (id_pc_w)            
    );

//==========================================================//
//                       ID stage                           //
//==========================================================//
    // Done signal latch
    always @(posedge clk_i or negedge reset_ni) begin
        if (!reset_ni) 
            id_done_r <= 1'b0;
        else if (id_done_w) 
            id_done_r <= 1'b1; 
    end

    // Flush delay from IF/ID to ID/EX (to implement flushing twice for two instructions)
    always @(posedge clk_i or negedge reset_ni) begin
        if (!reset_ni) 
            flush_delay_r <= 1'b0;
        else          
            flush_delay_r <= flush_if_id_w; 
    end
  
    control_unit ctrl_unit(
        .opcode_i       (instr_i[6:0]), 
        .funct3_i       (instr_i[14:12]), 
        .funct7_i       (instr_i[31:25]),
        .op1sel_o       (id_op1sel_w), 
        .op2sel_o       (id_op2sel_w), 
        .reg_we_en_o    (id_reg_we_en_w), 
        .is_jalr_o      (id_is_jalr_w),
        .wb_sel_o       (id_wb_sel_w), 
        .alu_op_o       (id_alu_op_w), 
        .bju_op_o       (id_bju_op_w), 
        .imm_sel_o      (id_imm_sel_w), 
        .read_write_o   (id_read_write_w),
        .dmem_we_o      (id_dmem_we_w),   
        .is_load_o      (id_is_load_w),
        .done_o         (id_done_w)
    );

    reg_file register_file(
        .clk_i    (clk_i), 
        .rst_ni   (reset_ni),
        // ID stage
        .raddr1_i (instr_i[19:15]),  
        .raddr2_i (instr_i[24:20]),
        .rdata1_o (id_rs1_data_w), 
        .rdata2_o (id_rs2_data_w),
        // WB stage 
        .we_i     (wb_reg_we_w), 
        .waddr_i  (wb_rd_addr_w),      
        .wdata_i  (wb_wdata_w)      
    );

    imme_gen immediate_generator (
        .in_i       (instr_i[31:7]),
        .imm_sel_i  (id_imm_sel_w), 
        .out_o      (id_imm_w)
    );
    
     hazard_detection_unit hdu (
        // ID stage
        .id_rs1_i          (instr_i[19:15]), 
        .id_rs2_i          (instr_i[24:20]), 
        // EX stage
        .ex_rd_i           (ex_rd_in_w),          
        .ex_is_load_i      (ex_is_load_w),      
        .ex_branch_taken_i (ex_branch_taken_w),   
       
        .stall_pc_if_id_o  (stall_pc_if_id_w),
        .flush_if_id_o     (flush_if_id_w),
        .flush_id_ex_o     (flush_id_ex_w)
    );

//==========================================================//
//                ID/EX Pipeline Register                   //
//==========================================================//   
    id_ex_reg id_ex_pipeline_reg (
        .clk_i         (clk_i),
        .rst_ni        (reset_ni),
        .flush_i       (flush_id_ex_w | flush_delay_r),
        // ID input
        .pc_i          (id_pc_w),
        .rd_i          (instr_i[11:7]),      
        .rs1_addr_i    (instr_i[19:15]),     
        .rs2_addr_i    (instr_i[24:20]),
        .rs1_i         (id_rs1_data_w),
        .rs2_i         (id_rs2_data_w),
        .imm_i         (id_imm_w),
        .d1_alusel_i   (id_op1sel_w),
        .d2_alusel_i   (id_op2sel_w),
        .d1_bjsel_i    (id_d1_bjsel_w),
        .d2_bjsel_i    (id_d2_bjsel_w),
        .op_alu_i      (id_alu_op_w),
        .bju_op_i   (id_bju_op_w),      
        .is_load_i     (id_is_load_w),
        .dmem_we_i     (id_dmem_we_w),  
        .rw_dmem_i     (id_read_write_w),
        .is_jalr_i     (id_is_jalr_w),
        .wb_sel_i      (id_wb_sel_w),
        .reg_we_i      (id_reg_we_en_w),
        .done_i        (id_done_r),

        // EX output
        .pc_o          (ex_pc_in_w),
        .rd_o          (ex_rd_in_w),
        .rs1_addr_o    (ex_rs1_addr_w),
        .rs2_addr_o    (ex_rs2_addr_w),
        .rs1_o         (ex_rs1_data_w),
        .rs2_o         (ex_rs2_data_w),
        .imm_o         (ex_imm_in_w),
        .d1_alusel_o   (ex_d1_alusel_w),
        .d2_alusel_o   (ex_d2_alusel_w),
        .d1_bjsel_o    (ex_d1_bjsel_w),
        .d2_bjsel_o    (ex_d2_bjsel_w),
        .op_alu_o      (ex_op_alu_w),
        .bju_op_o   (ex_bju_op_w),
        .is_jalr_o     (ex_is_jalr_w),
        .is_load_o     (ex_is_load_w),
        .dmem_we_o     (ex_dmem_we_w),
        .rw_dmem_o     (ex_rw_dmem_w),
        .wb_sel_o     (ex_wb_sel_w),
        .reg_we_o      (ex_reg_we_w),
        .done_o        (ex_done_w)
    );

//==========================================================//
//                       EX stage                           //
//==========================================================//
    forwarding_unit fwd_unit (
        .ex_rs1_addr_i   (ex_rs1_addr_w),         
        .ex_rs2_addr_i   (ex_rs2_addr_w),
        .mem_rd_addr_i   (mem_rd_in_w),            
        .mem_write_i     (mem_reg_we_w),
        .wb_rd_addr_i    (wb_rd_addr_w),                
        .wb_write_i      (wb_reg_we_w),
        .ex_rs1_sel_o    (fw_sel_rs1_w),          
        .ex_rs2_sel_o    (fw_sel_rs2_w)            
    );
    
    mux_4x1_32bit fwd_mux_a (
        .in0 (ex_rs1_data_w),        
        .in1 (mem_alu_res_w),    
        .in2 (wb_wdata_w),          
        .in3 (32'b0),             
        .sel (fw_sel_rs1_w),
        .out (fw_data1_w)
    );

    mux_4x1_32bit fwd_mux_b (
        .in0 (ex_rs2_data_w),        
        .in1 (mem_alu_res_w),    
        .in2 (wb_wdata_w),          
        .in3 (32'b0),
        .sel (fw_sel_rs2_w),
        .out (fw_data2_w)      
    );

    // Get ALU operand 1 and operand 2
    assign ex_alu_operand_a_w = (ex_d1_alusel_w) ? ex_pc_in_w : fw_data1_w;
    assign ex_alu_operand_b_w = (ex_d2_alusel_w) ? ex_imm_in_w : fw_data2_w;

    alu alu_unit (
        .operand_a_i    (ex_alu_operand_a_w),
        .operand_b_i    (ex_alu_operand_b_w),
        .alu_op_i       (ex_op_alu_w),
        .alu_data_o     (ex_alu_res_w)
    );
    
     bj_detect bj_unit (
        .op_i          (ex_bju_op_w),        
        .data1_i       (fw_data1_w),   
        .data2_i       (fw_data2_w),
        .is_jalr_i     (ex_is_jalr_w),
        .pc_i          (ex_pc_in_w),
        .imm_i         (ex_imm_in_w),
        
        .b_target_o    (ex_branch_target_w), 
        .b_taken_o     (ex_branch_taken_w)                    
    );
    
//==========================================================//
//                EX/MEM Pipeline Register                  //
//==========================================================//   
    ex_mem_reg    ex_mem_pipeline_reg(
        .clk_i       (clk_i),
        .rst_ni        (reset_ni),        
        // EX input
        .pc_i          (ex_pc_in_w),
        .rd_i          (ex_rd_in_w),
        .alu_i         (ex_alu_res_w),   
        .imm_i         (ex_imm_in_w),
        .d_dmem_i      (fw_data2_w),
        .is_load_i     (ex_is_load_w),
        .dmem_we_i     (ex_dmem_we_w),
        .rw_dmem_i     (ex_rw_dmem_w),
        .wb_sel_i     (ex_wb_sel_w),
        .reg_we_i  (ex_reg_we_w),
        .done_i        (ex_done_w),

        // MEM output
        .pc_o          (mem_pc_w),
        .rd_o          (mem_rd_in_w),
        .alu_o         (mem_alu_res_w),
        .imm_o         (mem_imm_w),
        .d_dmem_o      (mem_write_data_w),
        .is_load_o     (mem_is_load_w),
        .dmem_we_o     (mem_dmem_we_w),
        .rw_dmem_o     (mem_rw_dmem_w),
        .wb_sel_o     (mem_wb_sel_w),
        .reg_we_o  (mem_reg_we_w),
        .done_o  (mem_done_w) 
    );
    
//==========================================================//
//                      MEM stage                           //
//==========================================================//
    // Wire ALU result to BRAM address input
    assign data_addr_o   = mem_alu_res_w;
    
    // Enable BRAM when theres read/write signal
    assign data_en_o     = mem_dmem_we_w | mem_is_load_w;
    
    store_alignment store_align_unit (
        .mem_read_write_i (mem_rw_dmem_w),        
        .addr_offset_i    (mem_alu_res_w[1:0]), 
        .rs2_data_i       (mem_write_data_w),      
        .aligned_data_o   (data_wdata_o),        
        .byte_enable_o    (mem_aligned_byte_en_w)  
    );
    
    // DMEM write enable
    assign data_we_o     = (mem_dmem_we_w) ? mem_aligned_byte_en_w : 4'b0000;
    
//==========================================================//
//                MEM/WB Pipeline Register                  //
//==========================================================//   
    //Done signal
    assign done_o =    mem_done_w;
         
    mem_wb_reg  mem_wb_pipeline_reg(
        .clk_i         (clk_i),
        .rst_ni        (reset_ni),
        
        // MEM input
        .pc_i          (mem_pc_w),
        .rd_i          (mem_rd_in_w),
        .alu_i         (mem_alu_res_w),
        .imm_i         (mem_imm_w),
        .rw_dmem_i     (mem_rw_dmem_w),       
        .wb_sel_i      (mem_wb_sel_w),
        .reg_we_i       (mem_reg_we_w),

        // WB output
        .pc_o          (wb_pc_out_w),
        .rd_o          (wb_rd_addr_w),
        .alu_o         (wb_alu_res_w),
        .imm_o         (wb_imm_out_w),
        .rw_dmem_o     (wb_read_write),
        .wb_sel_o      (wb_sel_w),
        .reg_we_o      (wb_reg_we_w)
    );
    
//==========================================================//
//                       WB stage                           //
//==========================================================//
    load_alignment load_align_unit (
        .wb_read_write_i (wb_read_write),         
        .addr_offset_i   (wb_alu_res_w[1:0]),  
        .mem_data_i      (data_rdata_i),          // Read data from BRAM (BRAM skip pipeline register)
        .wb_data_o       (wb_load_data_w)   
    );
    
    mux_4x1_32bit wb_mux (
        .in0 (wb_alu_res_w),   
        .in1 (wb_load_data_w),
        .in2 (wb_imm_out_w),            
        .in3 (wb_pc_out_w + 32'd4),
        .sel (wb_sel_w),
        .out (wb_wdata_w)          
    );
    
endmodule