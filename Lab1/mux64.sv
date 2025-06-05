`timescale 1ns / 1ps

module mux64 ( 
        input logic sel,
        input logic [63:0] a,
        input logic [63:0] b,
        output logic [63:0] y
);

always_comb begin
        y = sel ? a : b;
end

endmodule