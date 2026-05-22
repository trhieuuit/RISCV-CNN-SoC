`timescale 1ns / 1ps
`include "encoding.v"

module forwarding_unit_tb;

    //==========================================================//
    // Inputs
    //==========================================================//

    reg [4:0] ex_rs1_addr_i;
    reg [4:0] ex_rs2_addr_i;

    reg [4:0] mem_rd_addr_i;
    reg       mem_write_i;

    reg [4:0] wb_rd_addr_i;
    reg       wb_write_i;

    //==========================================================//
    // Outputs
    //==========================================================//

    wire [1:0] ex_rs1_sel_o;
    wire [1:0] ex_rs2_sel_o;

    //==========================================================//
    // DUT
    //==========================================================//

    forwarding_unit dut (
        .ex_rs1_addr_i(ex_rs1_addr_i),
        .ex_rs2_addr_i(ex_rs2_addr_i),

        .mem_rd_addr_i(mem_rd_addr_i),
        .mem_write_i  (mem_write_i),

        .wb_rd_addr_i (wb_rd_addr_i),
        .wb_write_i   (wb_write_i),

        .ex_rs1_sel_o (ex_rs1_sel_o),
        .ex_rs2_sel_o (ex_rs2_sel_o)
    );

    //==========================================================//
    // Test Sequence
    //==========================================================//

    initial begin

        ////////////////////////////////////////////////////////
        // TEST 1 : No forwarding
        ////////////////////////////////////////////////////////

        $display("TEST 1 : No forwarding");

        ex_rs1_addr_i = 5'd1;
        ex_rs2_addr_i = 5'd2;

        mem_rd_addr_i = 5'd3;
        mem_write_i   = 1'b1;

        wb_rd_addr_i  = 5'd4;
        wb_write_i    = 1'b1;

        #10;

        $display("RS1_SEL = %b | RS2_SEL = %b",
                  ex_rs1_sel_o, ex_rs2_sel_o);

        ////////////////////////////////////////////////////////
        // TEST 2 : Forward RS1 from MEM
        ////////////////////////////////////////////////////////

        $display("TEST 2 : Forward RS1 from MEM");

        ex_rs1_addr_i = 5'd3;
        ex_rs2_addr_i = 5'd2;

        mem_rd_addr_i = 5'd3;
        mem_write_i   = 1'b1;

        wb_rd_addr_i  = 5'd4;
        wb_write_i    = 1'b1;

        #10;

        $display("RS1_SEL = %b | RS2_SEL = %b",
                  ex_rs1_sel_o, ex_rs2_sel_o);

        ////////////////////////////////////////////////////////
        // TEST 3 : Forward RS1 from WB
        ////////////////////////////////////////////////////////

        $display("TEST 3 : Forward RS1 from WB");

        ex_rs1_addr_i = 5'd4;
        ex_rs2_addr_i = 5'd2;

        mem_rd_addr_i = 5'd6;
        mem_write_i   = 1'b1;

        wb_rd_addr_i  = 5'd4;
        wb_write_i    = 1'b1;

        #10;

        $display("RS1_SEL = %b | RS2_SEL = %b",
                  ex_rs1_sel_o, ex_rs2_sel_o);

        ////////////////////////////////////////////////////////
        // TEST 4 : MEM priority over WB
        ////////////////////////////////////////////////////////

        $display("TEST 4 : MEM priority over WB");

        ex_rs1_addr_i = 5'd5;

        mem_rd_addr_i = 5'd5;
        mem_write_i   = 1'b1;

        wb_rd_addr_i  = 5'd5;
        wb_write_i    = 1'b1;

        #10;

        $display("RS1_SEL = %b",
                  ex_rs1_sel_o);

        ////////////////////////////////////////////////////////
        // TEST 5 : x0 should never forward
        ////////////////////////////////////////////////////////

        $display("TEST 5 : x0 should never forward");

        ex_rs1_addr_i = 5'd0;
        ex_rs2_addr_i = 5'd0;

        mem_rd_addr_i = 5'd0;
        mem_write_i   = 1'b1;

        wb_rd_addr_i  = 5'd0;
        wb_write_i    = 1'b1;

        #10;

        $display("RS1_SEL = %b | RS2_SEL = %b",
                  ex_rs1_sel_o, ex_rs2_sel_o);

        ////////////////////////////////////////////////////////
        // Finish
        ////////////////////////////////////////////////////////

        $finish;

    end

endmodule