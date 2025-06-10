`timescale 1ns / 1ps

module add1TB ();

logic in1TB, in2TB, cinTB, coutTB, outTB;

add1 dut(
    in1TB,
    in2TB,
    cinTB,
    coutTB,
    outTB
);

initial begin

    in1TB = 0;
    in2TB = 0;
    cinTB = 0;
    #10;
    
    in1TB = 0;
    in2TB = 0;
    cinTB = 1;
    #10;
    
    in1TB = 0;
    in2TB = 1;
    cinTB = 0;
    #10;
    
    in1TB = 0;
    in2TB = 1;
    cinTB = 1;
    #10;
    
    in1TB = 1;
    in2TB = 0;
    cinTB = 0;
    #10;
    
    in1TB = 1;
    in2TB = 0;
    cinTB = 1;
    #10;
    
    in1TB = 1;
    in2TB = 1;
    cinTB = 0;
    #10;
    
    in1TB = 1;
    in2TB = 1;
    cinTB = 1;
    #10;
    
    $finish;

    end
endmodule