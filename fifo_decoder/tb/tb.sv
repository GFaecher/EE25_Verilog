`timescale 100ns/1ps
`include "/data/cad/group/tolu/fifo_decoder/fifo_decoder.sv"

module tb ();
    logic clk;
    logic rstn;
    logic en;
    logic stall;
    logic [3:0] din;
    logic [3:0] dout;

    fifo_decoder #(
        .DW(4),
        .LENGTH(4)
        ) ff0 (
        .CLK(clk),
        .RSTN(rstn),
        .EN(en),
        .STALL(stall),
        .DIN(din),
        .DOUT(dout)
    );


    initial begin
        clk = 1'b0;
        forever #50 clk = ~clk;
    end

    initial begin
        #40000 $finish;
    end

    initial begin
        rstn = 1'b0;
        en = 1'b0;
        stall = 1'b1;
        #100 rstn = 1;
        #50 en = 1'b1;
        stall = 1'b0;
        @(posedge clk) din = 4'd3;
        @(posedge clk) stall = 1'b1;
        #(100 * $urandom_range(1, 5));
        stall = 1'b0;
        @(posedge clk) din = 4'd2;
        @(posedge clk) din = 4'd5;
        @(posedge clk) din = 4'd1;
        @(posedge clk) din = 4'd4;
        @(posedge clk) din = 4'd7;
        @(posedge clk) din = 4'd0;
        @(posedge clk) stall = 1'b1;
        #(100 * $urandom_range(1, 5));
        stall = 1'b0;
        @(posedge clk) din = 4'd6;
        @(posedge clk) din = 4'd2;
        @(posedge clk) stall = 1'b1;
        #(100 * $urandom_range(1, 5));
        stall = 1'b0;
        @(posedge clk) din = 4'd1;
        @(posedge clk) stall = 1'b1;

        #1000 @(posedge clk) $finish();
    end
endmodule