`timescale 1ns / 1ps

module mux5 ( 
        input logic sel,
        input logic [4:0] a,
        input logic [4:0] b,
        output logic [4:0] y
);

always_comb begin
        y = sel ? a : b;
end

endmodule