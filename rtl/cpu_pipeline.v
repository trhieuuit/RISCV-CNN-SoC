
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Hieu
// 
// Create Date: 03/05/2026 09:40:13 PM
// Design Name: 
// Module Name: cpu_pipeline
// Target Devices: 
// Tool Versions: 
// Description: 5-Stage RISC-V Pipelined CPU Top Level
//////////////////////////////////////////////////////////////////////////////////

module cpu_pipeline(
    input  wire        clk,
    input  wire        reset_ni,
    
    // Cổng IMEM (Tầng IF)
    output wire [31:0] inst_addr_o,  
    output wire        inst_en_o,    // Chân kích hoạt BRAM 
    input  wire [31:0] instruction, 
    
    // Cổng DMEM (Tầng MEM)
    output wire [31:0] data_addr_o,    
    output wire [31:0] data_wdata_o,   
    output wire        data_en_o,    // Chân kích hoạt BRAM 
    output wire [3:0]  data_we_o,    // Chân cho phép Ghi 
    input  wire [31:0] data_rdata_i,  
    
 
    output wire        rv_done_o
);

    // ===========================================================================
    // KHAI BÁO DÂY DẪN 
    // ===========================================================================

    // --- TÍN HIỆU ĐIỀU KHIỂN TOÀN CỤC ---
    wire stall_pc_if_id; 
    wire flush_if_id;   
    wire flush_id_ex;



    // --- DÂY VÒNG VỀ TỪ TẦNG EX ---

    wire [31:0] ex_branch_target;
    wire        ex_branch_taken;

    // --- DÂY TẦNG IF (Instruction Fetch) ---
    wire [31:0] if_pc_next;
    wire [31:0] if_pc_plus_4;
    wire        if_pc_sel;       
    wire [31:0] if_pc;
    // --- DÂY TẦNG ID (Instruction Decode) ---
    wire [31:0] id_pc;           
    wire [31:0] id_instr;        
    wire [31:0] id_rs1_data;
    wire [31:0] id_rs2_data;
    wire [31:0] id_imm;
    
    wire        id_op1sel;
    wire        id_op2sel;
    wire        id_reg_write_en;
    wire [1:0]  id_wb_sel;
    wire [4:0]  id_aluop;
    wire [2:0]  id_branch_jump;
    wire [2:0]  id_imm_sel;
    wire [3:0]  id_read_write;
    
    // Các dây điều khiển mở rộng 
    wire [1:0]  id_d1_bjsel, id_d2_bjsel;
    wire        id_d_dmemsel;
    wire        id_we_dmem;
    wire        id_is_jalr;

    // --- DÂY  TẦNG EX (ĐẦU RA TỪ THANH GHI ID/EX) ---
    wire [31:0] ex_pc_in;
    wire [4:0]  ex_rd_in;
    wire [4:0]  ex_rs1_addr;     
    wire [4:0]  ex_rs2_addr;     
    wire [31:0] ex_rs1_data;
    wire [31:0] ex_rs2_data;
    wire [31:0] ex_imm_in;

    wire [1:0]  ex_d1_alusel;
    wire [1:0]  ex_d2_alusel;
    wire [1:0]  ex_d1_bjsel;
    wire [1:0]  ex_d2_bjsel;
    wire [4:0]  ex_op_alu;
    wire [2:0]  ex_op_bl;
    wire        ex_is_jalr;
    wire        ex_d_dmemsel;
    wire        ex_we_dmem;
    wire [3:0]  ex_rw_dmem;
    wire [1:0]  ex_d_wbsel;
    wire        ex_we_regfile;
    
    // --- DÂY  TẦNG MEM (ĐẦU RA TỪ THANH GHI EX/MEM) ---
    wire [4:0]  mem_rd_in;
    wire [31:0] mem_alu_result;
    wire [31:0] mem_write_data;
    
    wire        mem_d_dmemsel_o;
    wire        mem_we_dmem_o;
    wire [3:0]  mem_rw_dmem_o;
    wire [1:0]  mem_d_wbsel_o;
    wire        mem_we_regfile_o;
     
    wire [31:0] mem_pc_in;  
    wire [31:0] mem_imm_in;
    
    
    // --- DÂY VÒNG VỀ TỪ WB ---
    wire        wb_reg_write_en; 
    wire [4:0]  wb_rd;           
    wire [31:0] wb_wdata;        


    // ===========================================================================
    // 1. TẦNG FETCH (IF)
    // ===========================================================================
    assign if_pc_plus_4 = if_pc + 32'd4;                   
//    assign if_pc_next = (!reset_ni) ? 32'h00000000 : 
//                        (ex_branch_taken) ? ex_branch_target : if_pc_plus_4;

    reg cpu_halted;
    assign if_pc_next = (!reset_ni)   ? 32'h00000000 : 
                    (cpu_halted)  ? if_pc :       
                    (ex_branch_taken) ? ex_branch_target : 
                    if_pc_plus_4;
                        
    // Xuất địa chỉ ra BRAM
    assign inst_addr_o = if_pc;

    // Kích hoạt BRAM Lệnh (Đóng băng BRAM nếu bị Stall để tiết kiệm điện và tránh lỗi)
    assign inst_en_o = ~stall_pc_if_id;

    pc program_counter (
        .clk_i   (clk),
        .rst_ni  (reset_ni),
        .stall_i (stall_pc_if_id), // Cắm dây  từ HDU 
        .pc_next (if_pc_next),
        .pc_o    (if_pc)           // Xuất ra PC hiện tại
    );

    
    if_id_reg if_id_pipeline_reg (
        .clk_i   (clk), 
        .rst_ni  (reset_ni),
        .stall_i (stall_pc_if_id), // Dây HDU
        .flush_i (flush_if_id),    // Dây HDU
        .pc_i    (if_pc),   
        .pc_o    (id_pc)           
    );
    
  


    // ===========================================================================
    // 2. TẦNG DECODE & REGISTER (ID)
    // ===========================================================================
    
    wire id_ecall; 
    always @(posedge clk or negedge reset_ni) begin
        if (!reset_ni) 
            cpu_halted <= 1'b0;
        else if (id_ecall) 
            cpu_halted <= 1'b1; 
    end

    // Xuất tín hiệu ra ngoài 
    assign rv_done_o = cpu_halted;
    
    
    reg flush_delay;
    always @(posedge clk or negedge reset_ni) begin
        if (!reset_ni) flush_delay <= 1'b0;
        else           flush_delay <= flush_if_id; 
    end
    
  
    wire is_u_type = (id_instr[6:0] == 7'b0110111) || (id_instr[6:0] == 7'b0010111); // LUI, AUIPC
    wire is_j_type = (id_instr[6:0] == 7'b1101111); // JAL
    
   
    wire [4:0] clean_rs1_addr = (is_u_type || is_j_type) ? 5'b0 : instruction[19:15];
 
    
    assign id_instr = (flush_if_id | flush_delay ) ? 32'h00000013 : instruction;
    control_unit ctrl_unit(
        .opcode           (id_instr[6:0]), 
        .funct3           (id_instr[14:12]), 
        .funct7           (id_instr[31:25]), 
        
        .op1sel_out       (id_op1sel), 
        .op2sel_out       (id_op2sel), 
        .reg_write_en_out (id_reg_write_en), 
        .is_jalr_o        (id_is_jalr),
        .wb_sel_out       (id_wb_sel), 
        .aluop_out        (id_aluop), 
        .branch_jump_out  (id_branch_jump), 
        .imm_sel_out      (id_imm_sel), 
        .read_write_out   (id_read_write),
        
         .we_dmem_out      (id_we_dmem),   
        .d_dmemsel_out    (id_d_dmemsel),
        .ecall_out (id_ecall)
    );

    reg_file register_file(
        .clk_i    (clk), 
        .rst_ni   (reset_ni), 
        
        // CỔNG ĐỌC (Tầng ID)
        .raddr1_i (clean_rs1_addr), 
        .raddr2_i (id_instr[24:20]), 
        .rdata1_o (id_rs1_data), 
        .rdata2_o (id_rs2_data),
        
        // CỔNG GHI (Tầng WB)
        .we_i     (wb_reg_write_en), 
        .waddr_i  (wb_rd),      
        .wdata_i  (wb_wdata)     
    );

    imme_gen immediate_generator (
        .in       (id_instr[31:7]), 
        .imm_sel  (id_imm_sel), 
        .out      (id_imm)
    );
 
    hazard_detection_unit hdu (
        .id_rs1          (clean_rs1_addr),
        .id_rs2          (id_instr[24:20]),
        
        .ex_rd           (ex_rd_in),          
        .ex_is_load      (ex_d_dmemsel),     
        .ex_branch_taken (ex_branch_taken),   
        
        .stall_pc_if_id  (stall_pc_if_id),
        .flush_if_id     (flush_if_id),
        .flush_id_ex     (flush_id_ex)
    );

    // ===========================================================================
    // THANH GHI ĐƯỜNG ỐNG ID/EX
    // ===========================================================================
    
   


    id_ex_reg id_ex_pipeline_reg (
        .clk_i         (clk),
        .rst_ni        (reset_ni),
        .flush_i       (flush_id_ex),

        // ĐẦU VÀO TỪ TẦNG ID
        .pc_i          (id_pc),
        .rd_i          (id_instr[11:7]),
        
       // .rs1_addr_i    (id_instr[19:15]), 
       .rs1_addr_i    (clean_rs1_addr), 
        .rs2_addr_i    (id_instr[24:20]), 
        
        .rs1_i         (id_rs1_data),
        .rs2_i         (id_rs2_data),
        .imm_i         (id_imm),

        .d1_alusel_i   (id_op1sel),
        .d2_alusel_i   (id_op2sel),
        .d1_bjsel_i    (id_d1_bjsel),
        .d2_bjsel_i    (id_d2_bjsel),
        .op_alu_i      (id_aluop),
        .op_bl_i       (id_branch_jump),      //  Nối dây từ Control Unit
        .d_dmemsel_i   (id_d_dmemsel),
        .we_dmem_i     (id_we_dmem),  
        .rw_dmem_i     (id_read_write),
        .is_jalr_i      (id_is_jalr),
        .d_wbsel_i     (id_wb_sel),
        .we_regfile_i  (id_reg_write_en),

        // ĐẦU RA CHO TẦNG EX
        .pc_o          (ex_pc_in),
        .rd_o          (ex_rd_in),
        
        .rs1_addr_o    (ex_rs1_addr),
        .rs2_addr_o    (ex_rs2_addr),
        
        .rs1_o         (ex_rs1_data),
        .rs2_o         (ex_rs2_data),
        .imm_o         (ex_imm_in),

        .d1_alusel_o   (ex_d1_alusel),
        .d2_alusel_o   (ex_d2_alusel),
        .d1_bjsel_o    (ex_d1_bjsel),
        .d2_bjsel_o    (ex_d2_bjsel),
        .op_alu_o      (ex_op_alu),
        .op_bl_o       (ex_op_bl),
        .is_jalr_o      (ex_is_jalr),
        .d_dmemsel_o   (ex_d_dmemsel),
        .we_dmem_o     (ex_we_dmem),
        .rw_dmem_o     (ex_rw_dmem),
        .d_wbsel_o     (ex_d_wbsel),
        .we_regfile_o  (ex_we_regfile)
    );


    // ===========================================================================
    // 3. TẦNG EX
    // ===========================================================================
    wire [1:0]  fw_sel_rs1;
    wire [1:0]  fw_sel_rs2;
    wire [31:0] fw_data1_clean;
    wire [31:0] fw_data2_clean;
    wire [31:0] alu_operand_a;
    wire [31:0] alu_operand_b;
    wire [31:0] ex_alu_result;
  
    forwarding_unit fwd_unit (
        .ex_rs1_addr   (ex_rs1_addr),         
        .ex_rs2_addr   (ex_rs2_addr),         
        
        .mem_rd_addr   (mem_rd_in),           
        .mem_write     (mem_we_regfile_o),    
        
        .wb_rd_addr    (wb_rd),               
        .wb_write      (wb_reg_write_en),     
        
        .ex_rs1_sel    (fw_sel_rs1),          
        .ex_rs2_sel    (fw_sel_rs2)           
    );

    mux_4x1_32bit fwd_mux_a (
        .in0 (ex_rs1_data),       
        .in1 (mem_alu_result),    
        .in2 (wb_wdata),          
        .in3 (32'b0),             
        .sel (fw_sel_rs1),
        .out (fw_data1_clean)
    );

    mux_4x1_32bit fwd_mux_b (
        .in0 (ex_rs2_data),       
        .in1 (mem_alu_result),    
        .in2 (wb_wdata),          
        .in3 (32'b0),
        .sel (fw_sel_rs2),
        .out (fw_data2_clean)     
    );

    assign alu_operand_a = (ex_d1_alusel) ? ex_pc_in : fw_data1_clean;
    assign alu_operand_b = (ex_d2_alusel) ? ex_imm_in : fw_data2_clean;

    alu alu_unit (
        .operand_a_i      (alu_operand_a),
        .operand_b_i      (alu_operand_b),
        .alu_op_i (ex_op_alu),      
        
        .alu_data_o (ex_alu_result)
    );
    
//    assign ex_branch_target = ex_pc_in + ex_imm_in;
      assign ex_branch_target = (ex_is_jalr) ? (fw_data1_clean + ex_imm_in) : (ex_pc_in + ex_imm_in);
    bj_detect bj_unit (
        .branch_jump_i (ex_op_bl),       
        .data1_i       (fw_data1_clean),   
        .data2_i       (fw_data2_clean),   
        
        .pc_sel_o      (ex_branch_taken)   
    );

    ex_mem_reg    ex_mem_pipeline_reg(
        .clk_i         (clk),
        .rst_ni        (reset_ni),
        .flush_i       (1'b0),            
        
        // ĐẦU VÀO TỪ TẦNG EX
        .pc_i          (ex_pc_in),
        .rd_i          (ex_rd_in),
        .alu_i     (ex_alu_result),   
        .imm_i         (ex_imm_in),
        .d_dmem_i      (fw_data2_clean),  
        
        .d_dmemsel_i   (ex_d_dmemsel),
        .we_dmem_i     (ex_we_dmem),
        .rw_dmem_i     (ex_rw_dmem),
        .d_wbsel_i     (ex_d_wbsel),
        .we_regfile_i  (ex_we_regfile),

        // ĐẦU RA CHO TẦNG MEM
        .pc_o          (mem_pc_in),
        .rd_o          (mem_rd_in),
        .alu_o     (mem_alu_result),
        .imm_o         (mem_imm_in),
        .d_dmem_o    (mem_write_data),
        
        .d_dmemsel_o   (mem_d_dmemsel_o),
        .we_dmem_o     (mem_we_dmem_o),
        .rw_dmem_o     (mem_rw_dmem_o),
        .d_wbsel_o     (mem_d_wbsel_o),
        .we_regfile_o  (mem_we_regfile_o)
        
    );
    
    // ===========================================================================
    // 4. TẦNG MEM (MEMORY ACCESS)
    // ===========================================================================
    assign data_addr_o     = mem_alu_result; 
  
   
    assign data_en_o = mem_we_dmem_o | mem_d_dmemsel_o;   // Kích hoạt BRAM Dữ liệu khi có lệnh Đọc VÀ Ghi

    // Chân Write Enable (4-bit). 
    wire [3:0] aligned_byte_enable;

    // STORE ALIGNMENT
    store_alignment store_align_unit (
        .mem_read_write_i (mem_rw_dmem_o),       // Tín hiệu loại lệnh Store 
        .addr_offset      (mem_alu_result[1:0]), // 2 bit cuối của địa chỉ ALU đ
        .rs2_data_i       (mem_write_data),      // Dữ liệu cần ghi
        
        .aligned_data_o   (data_wdata_o),       
        .byte_enable_o    (aligned_byte_enable)  // 4-bit byte enable
    );
    
    
    assign data_we_o = (mem_we_dmem_o) ? aligned_byte_enable : 4'b0000;
    wire [31:0] wb_pc_out;
    wire [31:0] wb_alu_result;
    wire [31:0] wb_imm_out;
    wire [31:0] wb_dmem_ignored; 
    wire [1:0]  wb_d_wbsel;
    
   // Cờ loại lệnh
    wire [3:0]  wb_rw_dmem;
    
    
    mem_wb_reg  mem_wb_pipeline_reg(
        .clk_i         (clk),
        .rst_ni        (reset_ni),
        .flush_i       (1'b0),              
        
        // ĐẦU VÀO TỪ TẦNG MEM
        .pc_i          (mem_pc_in),
        .rd_i          (mem_rd_in),
        .alu_i     (mem_alu_result),
        .imm_i         (mem_imm_in),
         
         .rw_dmem_i     (mem_rw_dmem_o),       
        .dmem_i        (32'b0),
        .d_wbsel_i     (mem_d_wbsel_o),
        .we_regfile_i  (mem_we_regfile_o),

        // ĐẦU RA CHO TẦNG WB
        .pc_o          (wb_pc_out),
        .rd_o          (wb_rd),
        .alu_o     (wb_alu_result),
        .imm_o         (wb_imm_out),
         
         .rw_dmem_o     (wb_rw_dmem),
        .dmem_o        (wb_dmem_ignored),
        .d_wbsel_o     (wb_d_wbsel),
        .we_regfile_o  (wb_reg_write_en)
    );

    // ===========================================================================
    // 5. TẦNG WB (WRITE-BACK)
    // ===========================================================================
    
    wire [31:0] aligned_load_data; 
    
    load_alignment load_align_unit (
        .wb_read_write_i (wb_rw_dmem),         // Cờ loại lệnh
        .addr_offset     (wb_alu_result[1:0]), // Lấy 2 bit cuối của địa chỉ ALU
        .mem_data_i      (data_rdata_i),       // Dữ liệu  từ BRAM 
        
        .wb_data_o       (aligned_load_data)   // Dữ liệu sau align
    );
    
    mux_4x1_32bit wb_mux (
        .in0 (wb_alu_result),   
        .in1 (aligned_load_data),     
        
        .in2 (wb_imm_out),           
        .in3 (wb_pc_out + 32'd4),           
        
        .sel (wb_d_wbsel),
        .out (wb_wdata)         
    );
    
endmodule