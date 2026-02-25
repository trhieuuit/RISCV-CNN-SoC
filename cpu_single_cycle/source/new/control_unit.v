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

`include "encoding.v"

module control_unit(
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    
    output reg        op1sel_out, 
    output reg        op2sel_out, 
    output reg        reg_write_en_out,
    output reg  [1:0] wb_sel_out,
    output reg  [4:0] aluop_out,
    output reg  [2:0] branch_jump_out,
    output reg  [2:0] imm_sel_out,
    output reg  [3:0] read_write_out
);
    
    always @(*) begin

        op1sel_out       = `DATA1;           // Lấy thanh ghi rs1
        op2sel_out       = `DATA2;           // Lấy thanh ghi rs2
        reg_write_en_out = `REG_WRITE_EN_0;  // Không ghi
        wb_sel_out       = `ALU;             // Lấy kết quả ALU
        aluop_out        = `ADD;             // Mặc định cộng
        branch_jump_out  = `NO;              // Không nhảy (Mã 010)
        imm_sel_out      = `U_TYPE;          // Mặc định
        read_write_out   = `NO_RW;           // Không đụng vào RAM
        
      
 //  GIẢI MÃ LỆNH

        case(opcode)
            `R_TYPE_OPCODE: begin  
                reg_write_en_out = `REG_WRITE_EN_1;
                op1sel_out       = `DATA1;
                op2sel_out       = `DATA2;
                wb_sel_out       = `ALU;

                aluop_out        = {funct3, funct7[5], funct7[0]};
            end
            
            `I_TYPE_OPCODE: begin
                reg_write_en_out = `REG_WRITE_EN_1;
                op1sel_out       = `DATA1;
                op2sel_out       = `IMM;
                wb_sel_out       = `ALU;
                imm_sel_out      = `I_SIGNED_TYPE;
                
                // Các lệnh Shift (SLLI, SRLI, SRAI)
                if (funct3 == 3'b001 || funct3 == 3'b101) begin
                    aluop_out    = {funct3, funct7[5], 1'b0};
                end else begin
                    aluop_out    = {funct3, 2'b00};
                end
            end

            `LOAD_OPCODE: begin
                reg_write_en_out = `REG_WRITE_EN_1;
                op1sel_out       = `DATA1; 
                op2sel_out       = `IMM;   
                wb_sel_out       = `MEM;   // Ghi từ Data Memory
                imm_sel_out      = `I_SIGNED_TYPE;
                aluop_out        = `ADD;   // Tính địa chỉ nền + offset
                
                // Load Word, Half hay Byte
                case(funct3)
                    3'b000: read_write_out = `LB;
                    3'b001: read_write_out = `LH;
                    3'b010: read_write_out = `LW;
                    3'b100: read_write_out = `LBU;
                    3'b101: read_write_out = `LHU;
                    default: read_write_out = `NO_RW;
                endcase
            end

            `STORE_OPCODE: begin
                reg_write_en_out = `REG_WRITE_EN_0; 
                op1sel_out       = `DATA1; 
                op2sel_out       = `IMM; 
                imm_sel_out      = `S_TYPE;
                aluop_out        = `ADD; 
                
                case(funct3)
                    3'b000: read_write_out = `SB;
                    3'b001: read_write_out = `SH;
                    3'b010: read_write_out = `SW;
                    default: read_write_out = `NO_RW;
                endcase
            end

            `B_TYPE_OPCODE: begin
                reg_write_en_out = `REG_WRITE_EN_0;
                op1sel_out       = `PC; 
                op2sel_out       = `IMM; 
                imm_sel_out      = `B_TYPE;
                aluop_out        = `ADD; 
                // Mã BEQ, BNE = funct3
                branch_jump_out  = funct3; 
            end

            `JAL_OPCODE: begin
                reg_write_en_out = `REG_WRITE_EN_1; 
                op1sel_out       = `PC; 
                op2sel_out       = `IMM; 
                wb_sel_out       = `PC_4; // Kéo thẳng dây PC+4 vào Register File
                imm_sel_out      = `J_TYPE;
                aluop_out        = `ADD; 
                branch_jump_out  = `J;    // Mã nhảy vô điều kiện
            end

            `JALR_OPCODE: begin
                reg_write_en_out = `REG_WRITE_EN_1;
                op1sel_out       = `DATA1; // JALR lấy rs1 cộng offset
                op2sel_out       = `IMM; 
                wb_sel_out       = `PC_4; 
                imm_sel_out      = `I_SIGNED_TYPE;
                aluop_out        = `ADD; 
                branch_jump_out  = `J;
            end

            `LUI_OPCODE: begin
                reg_write_en_out = `REG_WRITE_EN_1;
                op1sel_out       = `DATA1; // Bỏ qua
                op2sel_out       = `IMM; 
                wb_sel_out       = `IMM_WB; 
                imm_sel_out      = `U_TYPE;
            end

            `AUIPC_OPCODE: begin
                reg_write_en_out = `REG_WRITE_EN_1;
                op1sel_out       = `PC; 
                op2sel_out       = `IMM; 
                wb_sel_out       = `ALU; 
                imm_sel_out      = `U_TYPE;
                aluop_out        = `ADD; 
            end

            default: begin
               
            end
        endcase
    end
endmodule