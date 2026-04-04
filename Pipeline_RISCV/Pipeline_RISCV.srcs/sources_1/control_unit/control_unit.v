`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2026 11:11:42 PM
// Design Name: 
// Module Name: control_unit
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
//                     Control Unit                         //
//==========================================================//
module control_unit(
    input  wire [6:0] opcode_i,
    input  wire [2:0] funct3_i,
    input  wire [6:0] funct7_i,             
    
    output reg        op1sel_o,           // ALU RS1 MUX
    output reg        op2sel_o,           // ALU RS2 MUX
    output reg  [4:0] aluop_o,            // ALU op selection
    
    output reg        reg_write_en_o,     // Register File Write enable
    output reg  [1:0] wb_sel_o,           // Register File Write back MUX

    output reg        is_jalr_o,          // Recognize jalr
    output reg  [2:0] branch_jump_o,      // Recognize Branch instructions
    
    output reg  [2:0] imm_sel_o,          // Immediate Gen op selection
    
    output reg  [3:0] read_write_o,       // Recognize Load/Store instructions for alignment modules
    output reg        we_dmem_o,          // DMEM write
    output reg        d_dmemsel_o,        // DMEM read
    
    output reg        ecall_o             // Recognize Ecall
);

//==========================================================//
//                     Default cases                        //
//==========================================================//
    always @(*) begin
        op1sel_o       = `DATA1;           
        op2sel_o       = `DATA2;           
        reg_write_en_o = `REG_WRITE_EN_0;  
        wb_sel_o       = `ALU;             
        aluop_o        = `ADD;             
        branch_jump_o  = `NO;              
        imm_sel_o      = `U_TYPE;          
        read_write_o   = `NO_RW;           
        is_jalr_o      = 1'b0;
        we_dmem_o      = 1'b0; 
        d_dmemsel_o    = 1'b0;
        ecall_o        = 1'b0;

//==========================================================//
//                     R - Type                             //
//==========================================================//
        case(opcode_i)
            `R_TYPE_OPCODE: begin  
                reg_write_en_o = `REG_WRITE_EN_1;
                op1sel_o       = `DATA1;
                op2sel_o       = `DATA2;
                wb_sel_o       = `ALU;
                aluop_o        = {funct3_i, funct7_i[5], funct7_i[0]};
            end
            
//==========================================================//
//                     I - Type                             //
//==========================================================//
            `I_TYPE_OPCODE: begin
                reg_write_en_o = `REG_WRITE_EN_1;
                op1sel_o       = `DATA1;
                op2sel_o       = `IMM;
                wb_sel_o       = `ALU;
                imm_sel_o      = `I_SIGNED_TYPE;
                
                // SLLI, SRLI, SRAI
                if (funct3_i == 3'b001 || funct3_i == 3'b101) begin
                    aluop_o    = {funct3_i, funct7_i[5], 1'b0};
                end else begin
                    aluop_o    = {funct3_i, 2'b00};
                end
            end

//==========================================================//
//                     Load - Type                          //
//==========================================================//
            `LOAD_OPCODE: begin
                reg_write_en_o = `REG_WRITE_EN_1;
                op1sel_o       = `DATA1; 
                op2sel_o       = `IMM;   
                wb_sel_o       = `MEM;   
                imm_sel_o      = `I_SIGNED_TYPE;
                aluop_o        = `ADD;   
                d_dmemsel_o = 1'b1;
                we_dmem_o      = 1'b0;
                
                // Load Word, Half, Byte
                case(funct3_i)
                    3'b000: read_write_o = `LB;
                    3'b001: read_write_o = `LH;
                    3'b010: read_write_o = `LW;
                    3'b100: read_write_o = `LBU;
                    3'b101: read_write_o = `LHU;
                    default: read_write_o = `NO_RW;
                endcase
            end
//==========================================================//
//                     Store - Type                         //
//==========================================================//
            `STORE_OPCODE: begin
                reg_write_en_o = `REG_WRITE_EN_0; 
                op1sel_o       = `DATA1; 
                op2sel_o       = `IMM; 
                imm_sel_o      = `S_TYPE;
                aluop_o        = `ADD; 
                d_dmemsel_o    = 1'b0;
                we_dmem_o      = 1'b1;
                
                // Word, Half or Byte
                case(funct3_i)
                    3'b000: read_write_o = `SB;
                    3'b001: read_write_o = `SH;
                    3'b010: read_write_o = `SW;
                    default: read_write_o = `NO_RW;
                endcase
            end

//==========================================================//
//                  Branch Type                             //
//==========================================================//
            `B_TYPE_OPCODE: begin
                reg_write_en_o = `REG_WRITE_EN_0;
                op1sel_o       = `PC; 
                op2sel_o       = `IMM; 
                imm_sel_o      = `B_TYPE;
                aluop_o        = `ADD; 
                branch_jump_o  = funct3_i; 
            end

//==========================================================//
//                  JAL instruction                         //
//==========================================================//
            `JAL_OPCODE: begin
                reg_write_en_o = `REG_WRITE_EN_1; 
                op1sel_o       = `PC; 
                op2sel_o       = `IMM; 
                wb_sel_o       = `PC_4; 
                imm_sel_o      = `J_TYPE;
                aluop_o        = `ADD; 
                branch_jump_o  = `J;    
            end

//==========================================================//
//                  JALR instruction                        //
//==========================================================//
            `JALR_OPCODE: begin
                reg_write_en_o = `REG_WRITE_EN_1;
                op1sel_o       = `DATA1; 
                op2sel_o       = `IMM; 
                wb_sel_o       = `PC_4; 
                imm_sel_o      = `I_SIGNED_TYPE;
                aluop_o        = `ADD; 
                branch_jump_o  = `J;
                is_jalr_o        = 1'b1;
            end

//==========================================================//
//                  LUI instruction                         //
//==========================================================//
            `LUI_OPCODE: begin
                reg_write_en_o = `REG_WRITE_EN_1;
                op1sel_o       = `DATA1; 
                op2sel_o       = `IMM; 
                wb_sel_o       = 2'b00; 
                imm_sel_o      = `U_TYPE;
            end

//==========================================================//
//                  AUIPC instruction                       //
//==========================================================//
            `AUIPC_OPCODE: begin
                reg_write_en_o = `REG_WRITE_EN_1;
                op1sel_o       = `PC; 
                op2sel_o       = `IMM; 
                wb_sel_o       = `ALU; 
                imm_sel_o      = `U_TYPE;
                aluop_o        = `ADD; 
            end
            
//==========================================================//
//                  Ecall instruction                       //
//==========================================================//
            `SYSTEM_OPCODE: begin
                ecall_o = 1'b1; 
                reg_write_en_o = 1'b0;
                we_dmem_o      = 1'b0;
                branch_jump_o  = `NO;
            end

            default: begin
            end
        endcase
    end
endmodule