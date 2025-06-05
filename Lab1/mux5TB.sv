`timescale 1ns / 1ps

module mux5TB ();

logic [4:0] aTB; 
logic [4:0] bTB; 
logic [4:0] yTB;
logic selTB;

mux5 dut(
        .a(aTB),
        .b(bTB),
        .y(yTB),
        .sel(selTB));

initial begin

        $dumpfile("dump.vcd");
        $dumpvars(0, mux5TB);
  
  
        aTB = 5'b11111; bTB = 5'b00000; selTB = 1'b0; #1;
  	aTB = 5'b11111; bTB = 5'b00000; selTB = 1'b1; #2; 
  
  
  	$finish;

end


endmodule