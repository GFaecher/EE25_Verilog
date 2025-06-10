`timescale 1ns / 1ps

module add1 (
    input logic in1,
    input logic in2,
    input logic cin,
    output logic cout,
    output logic out
);

    assign out = (in1 ^ in2 ^ cin);
    
    assign cout = ((in1 ^ in2) & cin) | (in1 & in2);
    

endmodule 