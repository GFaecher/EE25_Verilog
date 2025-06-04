`timescale 1ns / 1ps

module and2TB();

logic aTB, bTB, cTB;

and2 dut(
    .a(aTB),
    .b(bTB),
    .c(cTB)
);

initial begin
    // Setup waveform dump
    $dumpfile("dump.vcd");
    $dumpvars(0, and2TB);

    // Stimulus
    #1; aTB = 0; bTB = 0;
    #2; aTB = 1; bTB = 0;
    #3; aTB = 0; bTB = 1;
    #4; aTB = 1; bTB = 1;
    #5; $finish;  // end simulation
end

endmodule