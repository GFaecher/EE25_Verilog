// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module signExtendTB ();

        logic [31:0] xTB;
        logic [63:0] yTB;

        signExtend dut(
                xTB,
                yTB
        );

        /* Testing all I type instructions */ 

        initial begin

                $dumpfile("dump.vcd");
                $dumpvars(0, signExtendTB);

                xTB = 32'h24400C00; 
          #1; //ADDI with immediate of 0d2

                xTB = 32'h245FFC00; 
          #2; //ADDI with immediate of 0d-1

                xTB = 32'h24800C00; 
          #3; //ANDI with immediate of 0d2

                xTB = 32'h249FFC00; 
          #4; //ANDI with immediate of 0d-1

                xTB = 32'h2C800C00; 
          #5; //ORRI with immediate of 0d2

                xTB = 32'h2C9FFC00; 
          #6; //ORRI with immediate of 0d-1

                xTB = 32'h34400C00; 
          #7; //SUBI with immediate of 0d2

                xTB = 32'h345FFC00; 
          #8; //SUBI with immediate of 0d-1
                 
                $finish;

        end

endmodule