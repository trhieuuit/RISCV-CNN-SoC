`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2026 10:32:06 PM
// Design Name: 
// Module Name: bj_detect
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



module bj_detect(branch_jump, data1, data2, pc_sel_out);
    input [2:0] branch_jump;
    output pc_sel_out;
    input [31:0] data1,data2;

    wire eq, unsign_lt, sign_lt, pc_sel;
    reg lt;
    wire out1, out2, out3, out4, out5;

    assign #2 pc_sel_out = pc_sel;

    assign eq = data1 == data2 ? 1 : 0;
    assign unsign_lt = data1 < data2;
    assign sign_lt = ($signed(data1) < $signed(data2));


    always @(*) begin
        case (branch_jump[2:1])
            2'b11: lt = unsign_lt;
            default: lt = sign_lt;
        endcase
    end

    and logicand1(out1, !branch_jump[2], branch_jump[0], !eq);
    and logicand2(out2, !branch_jump[2], branch_jump[1], branch_jump[0]);
    and logicand3(out3, branch_jump[2], !branch_jump[0], lt);
    and logicand4(out4, branch_jump[2], eq, lt);
    and logicand5(out5, branch_jump[2], branch_jump[0], !lt);
    and logicand6(out6, !branch_jump[2], !branch_jump[1], !branch_jump[0], eq);

    or logicor(pc_sel, out1, out2, out3, out4, out5, out6);    

endmodule
