`timescale 1ns / 1ps

module signExtendTB ();

        logic [31:0] xTB;
        logic [63:0] yTB;

        signExtend dut(
                xTB,
                yTB
        );

        /* TESTING ALL I TYPE INSTRUCTION SIGN EXTENSION */ 

        initial begin

                $dumpfile("dump.vcd");
                $dumpvars(0, signExtendTB);

                 xTB = 32'b1001000100_000000000001_0000000000; 
           #10; //ADDI with immediate of 0d1

                 xTB = 32'b1001000100_111111111000_0000000000; 
           #10; //ADDI with immediate of 0d-8

                 xTB = 32'b1001001000_000000010000_0000000000; 
           #10; //ANDI with immediate of 0d16

                 xTB = 32'b1001001000_111111111110_0000000000; 
           #10; //ANDI with immediate of 0d-2

                 xTB = 32'b1011001000_000000100000_0000000000; 
           #10; //ORRI with immediate of 0d32

                 xTB = 32'b1011001000_111111111100_0000000000; 
           #10; //ORRI with immediate of 0d-4

                 xTB = 32'b1101000100_010000000000_0000000000; 
           #10; //SUBI with immediate of 0d1024

                 xTB = 32'b1101000100_111111111111_0000000000; 
           #10; //SUBI with immediate of 0d-1
           
                 xTB = 32'b0;
           #10; /* TESTING UNCONDITIONAL BRANCH SIGN EXTENSION */
           
                 xTB = 32'b000101_01000000000000000000000000;
                //B with immediate of 0d2^24
           #10;
            
                xTB = 32'b000101_10000000000000000000000000;
                //B with immediate of 0d-2^25
           #10;
           
                xTB = 32'b0;
           #10; /* TESTING CONDITIONAL BRANCH SIGN EXTENSION */
           
                xTB = 32'b10110100_010000000000000000000000;
                //CBZ with immediate of 0d2^17
                
           #10;
           
                xTB = 32'b10110100_100000000000000000000000; 
                //CBZ with immediate of 0d-2^18
           #10;
           
                xTB = 32'b10110101_010000000000000000000000;
                //CBNZ with immediate of 0d2^17
                
           #10;
           
                xTB = 32'b10110101_100000000000000000000000;    
                //CBNZ with immediate of 0d-2^18
                
           #10;
           
                xTB = 32'b0;
           
           #10; /* TESTING DATA TYPE SIGN EXTENSION */
           
                xTB = 32'b11111000000_010000000000000000000;
                //STUR with immediate of 0d2^7
                
           #10;
           
                xTB = 32'b11111000000_100000000000000000000; 
                //STUR with immediate of 0d-2^8
           #10;
           
                xTB = 32'b11111000010_010000000000000000000;
                //LDUR with immediate of 0d2^7
                
           #10;
           
                xTB = 32'b11111000010_100000000000000000000;    
                //LDUR with immediate of 0d-2^8
                
           #10;
           
                xTB = 32'b0;
           
           #10; /* TESTING R TYPE SHAMT SIGN EXTENSION */
           
                xTB = 32'b11010011010_00000_010000_0000000000;
                //LSR with immediate of 0d16
                
           #10;
           
                xTB = 32'b11010011010_00000_100000_0000000000; 
                //LSR with immediate of 0d-32
           #10;
           
                xTB = 32'b11010011011_00000_010000_0000000000;
                //LSL with immediate of 0d16
                
           #10;
           
                xTB = 32'b11010011011_00000_100000_0000000000;    
                //LSL with immediate of 0d-32
                
           #10;
           
                xTB = 32'b0;
           
           #10;
           
                $finish;

        end

endmodule