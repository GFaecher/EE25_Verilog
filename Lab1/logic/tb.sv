`timescale 1ns/1ps
module tb;

logic CLK;
logic RSTN;
logic [9:0] sample_i;
logic [19:0] sample_o;
logic weight;

initial
begin
  $timeformat(-9, 5, " ns", 10);
  #10000000;
  $display("Timeout reached");
  $finish;
end

initial
begin
CLK = 1'b0;
forever #10 CLK = ~CLK;
end

logic [9:0] sample_i_mem [2047:0];

integer i, fd, result;

initial 
begin 
  $readmemh("../logic/input.hex", sample_i_mem);
  $readmemh("../logic/coeff.hex", u_fir.h_mem);
end



initial
begin
  RSTN = 1'b0;
  sample_i = 10'd0;
  #500;
  RSTN = 1'b1;

  for (i=0; i<256; i=i+1)
  begin
    @(posedge CLK) sample_i = sample_i_mem[i];
    $display("%d, %d", sample_i, sample_o);
  end
  $finish();
end
    
FIR_63TAP u_fir(.CLK(CLK), .x(sample_i), .y(sample_o), .RSTN); 

initial
begin
  $dumpfile("FIR_tb.fsdb");
  $dumpvars(0);
end
endmodule
