`timescale 1ns / 1ps

module mux64TB ();

logic [63:0] aTB; 
logic [63:0] bTB; 
logic [63:0] yTB;
logic selTB;

mux64 dut(
        .a(aTB),
        .b(bTB),
        .y(yTB),
        .sel(selTB));

initial begin

        $dumpfile("dump.vcd");
        $dumpvars(0, mux64TB);
  
  
        aTB = 64'hFFFFFFFFFFFFFFFF; 
        bTB = 64'h0000000000000000; 
        selTB = 1'b0; 
        #1;

  	aTB = 64'hFFFFFFFFFFFFFFFF; 
        bTB = 64'h0000000000000000; 
        selTB = 1'b1; 
        #2;
  
  
  	$finish;

end


endmodule