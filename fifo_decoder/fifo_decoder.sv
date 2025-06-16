`include "./RTL.svh"
// TA 03 2025

module fifo_decoder #(
    parameter DW = 4,
    parameter LENGTH = 2,
    parameter AW = $clog2(LENGTH)
) (
    input logic CLK,
    input logic RSTN,
    input logic EN,
    input logic STALL,
    input logic [DW-1:0] DIN,
    output logic [DW-1:0] DOUT
);
    logic [AW:0] rd_addr, rd_addr_nxt;
    logic [AW:0] wr_addr, wr_addr_nxt;
    logic fifo_full, fifo_empty;
    logic read_repeat, read_repeat_nxt;
    logic [DW-1:0] fifo [0:LENGTH-1];
    logic [DW-1:0] din, dout;

    `FF(DIN, din, CLK, EN, RSTN, 0)

    always_comb begin
        fifo_empty = (rd_addr == wr_addr);
        fifo_full = (rd_addr[AW-1:0] == wr_addr[AW-1:0]) && (wr_addr[AW] != rd_addr[AW]);
    end


    always_comb read_repeat_nxt = (EN)? ~read_repeat : 1'b0;
    `FF(read_repeat_nxt, read_repeat, CLK, EN, RSTN, 0)

    always_comb wr_addr_nxt = (!STALL)? wr_addr + 1 : wr_addr;
    `FF(wr_addr_nxt, wr_addr, CLK, EN, RSTN, 0)

    always_comb rd_addr_nxt = (EN && read_repeat && !fifo_empty)? rd_addr + 1 : rd_addr;
    `FF(rd_addr_nxt, rd_addr, CLK, EN, RSTN, 0)

    always_comb begin
        if (!EN) begin
            for (int i = 0; i<LENGTH; i++) begin
                fifo[i] = '0;
            end
        end else begin
            fifo[wr_addr[AW-1:0]] = (!STALL && !fifo_full)? din : fifo[wr_addr[AW-1:0]];
        end
    end

    // always_comb fifo[wr_addr[AW-1:0]] = (!STALL && !fifo_full)? din : fifo[wr_addr[AW-1:0]];

    `FF(fifo[rd_addr[AW-1:0]], dout, CLK, EN, RSTN, 0)

    assign DOUT = dout;
endmodule