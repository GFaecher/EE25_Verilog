// AXI4-Lite Slave Wrapper for FIFO IP
module axi_fifo_slave_wrapper #(
    parameter C_S_AXI_DATA_WIDTH = 32,
    parameter C_S_AXI_ADDR_WIDTH = 4
)(
    // Global Signals
    input  wire                          s_axi_aclk,
    input  wire                          s_axi_aresetn,
    // Write address channel
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] s_axi_awaddr,
    input  wire                          s_axi_awvalid,
    output reg                           s_axi_awready,
    // Write data channel
    input  wire [C_S_AXI_DATA_WIDTH-1:0] s_axi_wdata,
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0] s_axi_wstrb,
    input  wire                          s_axi_wvalid,
    output reg                           s_axi_wready,
    // Write response channel
    output reg [1:0]                     s_axi_bresp,
    output reg                           s_axi_bvalid,
    input  wire                          s_axi_bready,
    // Read address channel
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] s_axi_araddr,
    input  wire                          s_axi_arvalid,
    output reg                           s_axi_arready,
    // Read data channel
    output reg [C_S_AXI_DATA_WIDTH-1:0]  s_axi_rdata,
    output reg [1:0]                     s_axi_rresp,
    output reg                           s_axi_rvalid,
    input  wire                          s_axi_rready
);

  //-------------------------------------------------------------------------
  // AXI4-Lite internal signals and registers
  //-------------------------------------------------------------------------
  // Register addresses (word-aligned)
  localparam REG_CONTROL = 4'h0;  // 0x00: Control register (bit0 = FIFO EN)
  localparam REG_DATA_IN = 4'h1;  // 0x04: Data input register (lower 4 bits used)
  localparam REG_DATA_OUT= 4'h2;  // 0x08: Data output register (read only)
  localparam REG_STATUS  = 4'h3;  // 0x0C: Status register (optional)

  // Slave register storage
  reg [C_S_AXI_DATA_WIDTH-1:0] reg_control;
  reg [C_S_AXI_DATA_WIDTH-1:0] reg_data_in;
  // For simplicity, we assume reg_data_out is driven directly from the FIFO.
  reg [C_S_AXI_DATA_WIDTH-1:0] reg_status; // Could be updated with status bits if available

  //-------------------------------------------------------------------------
  // AXI Write Address/ Data handshake
  //-------------------------------------------------------------------------
  always @(posedge s_axi_aclk) begin
    if (!s_axi_aresetn) begin
      s_axi_awready <= 1'b0;
      s_axi_wready  <= 1'b0;
    end else begin
      // Accept address when valid and ready low
      if (!s_axi_awready && s_axi_awvalid)
        s_axi_awready <= 1'b1;
      else
        s_axi_awready <= 1'b0;

      // Accept write data when valid and ready low
      if (!s_axi_wready && s_axi_wvalid)
        s_axi_wready <= 1'b1;
      else
        s_axi_wready <= 1'b0;
    end
  end

  //-------------------------------------------------------------------------
  // AXI Write Response logic
  //-------------------------------------------------------------------------
  always @(posedge s_axi_aclk) begin
    if (!s_axi_aresetn) begin
      s_axi_bvalid <= 1'b0;
      s_axi_bresp  <= 2'b0;
    end else begin
      // Generate write response when both address and data are accepted
      if (s_axi_awready && s_axi_awvalid && s_axi_wready && s_axi_wvalid) begin
        s_axi_bvalid <= 1'b1;
        s_axi_bresp  <= 2'b00; // OKAY response
      end else if (s_axi_bvalid && s_axi_bready) begin
        s_axi_bvalid <= 1'b0;
      end
    end
  end

  //-------------------------------------------------------------------------
  // Write Register Logic
  //-------------------------------------------------------------------------
  always @(posedge s_axi_aclk) begin
    if (!s_axi_aresetn) begin
      reg_control <= {C_S_AXI_DATA_WIDTH{1'b0}};
      reg_data_in <= {C_S_AXI_DATA_WIDTH{1'b0}};
    end else begin
      if (s_axi_awready && s_axi_awvalid && s_axi_wready && s_axi_wvalid) begin
        case (s_axi_awaddr[C_S_AXI_ADDR_WIDTH-1:0])
          REG_CONTROL: reg_control <= s_axi_wdata;
          REG_DATA_IN: reg_data_in <= s_axi_wdata;
          // Write to other registers can be added here if needed
          default: ;
        endcase
      end
    end
  end

  //-------------------------------------------------------------------------
  // AXI Read Address handshake and Read Data Logic
  //-------------------------------------------------------------------------
  always @(posedge s_axi_aclk) begin
    if (!s_axi_aresetn) begin
      s_axi_arready <= 1'b0;
      s_axi_rvalid  <= 1'b0;
      s_axi_rresp   <= 2'b0;
    end else begin
      // Accept read address when valid and ready low
      if (!s_axi_arready && s_axi_arvalid)
        s_axi_arready <= 1'b1;
      else
        s_axi_arready <= 1'b0;

      // Read data phase
      if (s_axi_arready && s_axi_arvalid) begin
        case (s_axi_araddr[C_S_AXI_ADDR_WIDTH-1:0])
          REG_CONTROL: s_axi_rdata <= reg_control;
          REG_DATA_IN: s_axi_rdata <= reg_data_in;
          REG_DATA_OUT: s_axi_rdata <= { {C_S_AXI_DATA_WIDTH-4{1'b0}}, fifo_data_out };
          REG_STATUS: s_axi_rdata <= reg_status; // Update status as needed
          default: s_axi_rdata <= {C_S_AXI_DATA_WIDTH{1'b0}};
        endcase
        s_axi_rvalid <= 1'b1;
        s_axi_rresp  <= 2'b00; // OKAY response
      end else if (s_axi_rvalid && s_axi_rready) begin
        s_axi_rvalid <= 1'b0;
      end
    end
  end

  //-------------------------------------------------------------------------
  // FIFO Instantiation
  //-------------------------------------------------------------------------
  // Wire for connecting FIFO data output
  wire [3:0] fifo_data_out;

  // Instantiate the FIFO IP
  fifo_two_cycle_row fifo_inst (
    .CLK     (s_axi_aclk),
    .RSTN    (s_axi_aresetn),
    .EN      (reg_control[0]),          // Use bit 0 of the control register as enable
    .data_in (reg_data_in[3:0]),         // Lower 4 bits from the DATA_IN register
    .data_out(fifo_data_out)
  );

  //-------------------------------------------------------------------------
  // (Optional) Status Register Update
  //-------------------------------------------------------------------------
  // If you choose to expose FIFO status (empty/full), update reg_status here.
  // For example, if your FIFO IP were modified to have status outputs:
  //   reg_status[0] <= fifo_empty;
  //   reg_status[1] <= fifo_full;
  // As the current FIFO IP does not expose these signals, we leave reg_status at 0.
  always @(posedge s_axi_aclk) begin
    if (!s_axi_aresetn)
      reg_status <= {C_S_AXI_DATA_WIDTH{1'b0}};
    else begin
      // Update reg_status as needed...
      reg_status <= {C_S_AXI_DATA_WIDTH{1'b0}};
    end
  end

endmodule
