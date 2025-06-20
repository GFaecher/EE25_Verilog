`timescale 1ns / 1ps

module shiftLeft2 (
        input logic [63:0] x,
        output logic [63:0] y
);

        always_comb begin

          y = {x[61:0], 2'b00};

        end

endmodule