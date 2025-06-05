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

                xTB = 32'h91000C00; 
          #1; //ADDI with immediate of 0d3

                xTB = 32'h911FFC00; 
          #2; //ADDI with immediate of 0d-1

                xTB = 32'h92000C00; 
          #3; //ANDI with immediate of 0d3

                xTB = 32'h921FFC00; 
          #4; //ANDI with immediate of 0d-1

                xTB = 32'hB2000C00; 
          #5; //ORRI with immediate of 0d3

                xTB = 32'hB21FFC00; 
          #6; //ORRI with immediate of 0d-1

                xTB = 32'hD1000C00; 
          #7; //SUBI with immediate of 0d3

                xTB = 32'hD11FFC00; 
          #8; //SUBI with immediate of 0d-1
                 
                $finish;

        end

endmodule