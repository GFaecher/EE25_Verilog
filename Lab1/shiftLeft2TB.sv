`timescale 1ns / 1ps

module shiftLeft2TB ();

        logic [63:0] xTB, yTB;

        shiftLeft2 dut(
                .x(xTB),
                .y(yTB)
        );

        initial begin

                $dumpfile("dump.vcd");
                $dumpvars(0, shiftLeft2TB);

                xTB = 64'hFFFFFFFFFFFFFFFF;
                #1;

                xTB = 64'h000000000000FF00;
                #2;

                $finish;

        end

endmodule