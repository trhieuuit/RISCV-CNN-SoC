

    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 02/26/2026 11:22:47 AM
    // Design Name: 
    // Module Name: div
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
    
    
    module unsigned_div(
        input wire          clk_i,
        input wire          rst_n,
        input wire          start_i,
        input wire  [31:0]  dividend_i,
        input wire  [31:0]  divisor_i,
        
        output reg  [31:0]  quotient_o,
        output reg  [31:0]  remainder_o,
        output reg          done_o
        );
        
        localparam CALC = 2'b01;
        localparam IDLE = 2'b00;
        localparam DONE = 2'b10;
        
        reg  [1:0]  state;
        reg  [5:0]  count;
        reg  [63:0] remainder;
        reg  [63:0] divisor;
        wire [64:0] sub = {1'b0, remainder} - {1'b0, divisor};
    
    always @(posedge clk_i) 
    begin
        if (!rst_n) begin
            quotient_o <= 0;
            remainder_o <= 0;
            done_o <= 0;
            count <= 0;
            state <= IDLE;
            divisor <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done_o <= 0;
                    if (start_i) begin
                        //Tin hieu bat dau
                        remainder <= {32'b0, dividend_i};
                        if (divisor_i == 0) begin
                            // Truong hop chia cho 0
                            quotient_o <= 32'hFFFFFFFF;
                            state <= DONE;
                         end else begin
                            // Cac truong hop con lai 
                            divisor <=  {1'b0, divisor_i, 31'b0};
                            quotient_o <= 0;
                            state <= CALC;
                            count <= 0;
                         end
                    end
                 end
                 
                 CALC: begin
                    if (count < 32) begin 
                        // Tinh toan ket qua
                        if (sub [64]) begin                 
                            quotient_o <= {quotient_o[30:0], 1'b0};
                        end else begin
                            remainder <= sub;
                            quotient_o <= {quotient_o[30:0], 1'b1};
                        end
                        
                        divisor <= {1'b0, divisor [63:1]};
                        count <= count + 1;
                        state <= CALC;
                        
                    end else begin
                        // Lay ket qua cuoi cung
                        remainder_o <= remainder[31:0];
                        state <= DONE;
                    end
                 end
                    
                 DONE: begin
                    //Xuat ket qua
                    done_o <= 1'b1;
                    state <= IDLE;
                 end 
            endcase 
        end
    end 
    endmodule
        
    

