`include "RTL.svh"

module FIR_63TAP (
    output logic [19:0] y,
    input  logic [9:0] x,
    input  logic CLK,
    input  logic RSTN
);  
    logic [9:0] h_mem [0:62];
    logic [19:0] y_mem [0:62];

    genvar i;
    generate for (i = 0; i < 62; i=i+1) begin
        always_ff @(posedge CLK, negedge RSTN) begin
            if (!RSTN) y_mem[i] <= 20'd0;
            else y_mem[i] <= y_mem[i+1] + {{10{x[9]}}, x[9:0]} * {{10{h_mem[i][9]}}, h_mem[i][9:0]}; 
        end
    end
    endgenerate
    
    `FF({{10{x[9]}}, x[9:0]} * {{10{h_mem[62][9]}}, h_mem[62]}, y_mem[62], CLK, '1, RSTN, '0);
    
    always_comb y = y_mem[0];
endmodule
