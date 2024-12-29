module nvdla_wrapper (
  // Clock
  input  dla_core_clk;                //|< i
  input  dla_csb_clk;                 //|< i
  input  global_clk_ovr_on;           //|< i
  input  tmc2slcg_disable_clock_gating;//|< i

  // Reset
  input  dla_reset_rstn;              //|< i
  input  direct_reset_;               //|< i

  // Test mode
  input  test_mode;                   //|< i

  // APB
  input pclk;                         //|< i
  input prstn;                        //|< i
  input psel;                         //|< i
  input penable;                      //|< i
  input pwrite;                       //|< i
  input [31:0] paddr;                 //|< i
  input [31:0] pwdata;                //|< i
  output [31:0] prdata;               //|> o
  output pready;                      //|> o

  // AXI
  output dbb_aw_awvalid;              //|> o
  input  dbb_aw_awready;              //|< i
  output [7:0] dbb_aw_awid;           //|> o
  output [3:0] dbb_aw_awlen;          //|> o
  output [63:0] dbb_aw_awaddr;        //|> o
  
  output dbb_w_wvalid;                //|> o
  input  dbb_w_wready;                //|< i
  output [511:0] dbb_w_wdata;         //|> o
  output [63:0] dbb_w_wstrb;          //|> o
  output dbb_w_wlast;                 //|> o

  input  dbb_b_bvalid;                //|< i
  output dbb_b_bready;                //|> o
  input  [7:0] dbb_b_bid;             //|< i

  output dbb_ar_arvalid;              //|> o
  input  dbb_ar_arready;              //|< i
  output [7:0] dbb_ar_arid;           //|> o
  output [3:0] dbb_ar_arlen;          //|> o
  output [63:0] dbb_ar_araddr;        //|> o

  input  dbb_r_rvalid;                //|< i
  output dbb_r_rready;                //|> o
  input  [7:0] dbb_r_rid;             //|< i
  input  dbb_r_rlast;                 //|< i
  input  [511:0] dbb_r_rdata;         //|< i

  // Interrupt
  output dla_intr;
);

  // APB to CSB
  logic apb2csb_valid;               //|> o
  logic  apb2csb_ready;               //|< i
  logic [15:0] apb2csb_addr;         //|> o
  logic [31:0] apb2csb_wdat;         //|> o
  logic apb2csb_write;               //|> o
  logic apb2csb_nposted;             //|> o
  logic  csb2apb_valid;               //|< i
  logic [31:0] csb2apb_data;          //|< i

  // CSB to NVDLA
  logic  csb2nvdla_valid;             //|< i
  logic csb2nvdla_ready;             //|> o
  logic  [15:0] csb2nvdla_addr;       //|< i
  logic  [31:0] csb2nvdla_wdat;       //|< i
  logic  csb2nvdla_write;             //|< i
  logic  csb2nvdla_nposted;           //|< i
  logic nvdla2csb_valid;             //|> o
  logic [31:0] nvdla2csb_data;       //|> o
  logic nvdla2csb_wr_complete;       //|> o

  // Power bus
  logic  [31:0] nvdla_pwrbus_ram_c_pd;
  logic  [31:0] nvdla_pwrbus_ram_ma_pd;
  logic  [31:0] nvdla_pwrbus_ram_mb_pd;
  logic  [31:0] nvdla_pwrbus_ram_p_pd;
  logic  [31:0] nvdla_pwrbus_ram_o_pd;
  logic  [31:0] nvdla_pwrbus_ram_a_pd;

// APB to CSB
NV_NVDLA_apb2csb apb2csb (
  .pclk              (pclk),              //|< i
  .prstn             (prstn),             //|< i
  
  // APB
  .psel              (psel),              //|< i
  .penable           (penable),           //|< i
  .pwrite            (pwrite),            //|< i
  .paddr             (paddr),             //|< i
  .pwdata            (pwdata),            //|< i
  .prdata            (prdata),            //|> o
  .pready            (pready),            //|> o

  // CSB
  .csb2nvdla_valid   (apb2csb_valid),     //|> o
  .csb2nvdla_ready   (apb2csb_ready),     //|< i
  .csb2nvdla_addr    (apb2csb_addr),      //|> o
  .csb2nvdla_wdat    (apb2csb_wdat),      //|> o
  .csb2nvdla_write   (apb2csb_write),     //|> o
  .csb2nvdla_nposted (apb2csb_nposted),   //|> o
  .nvdla2csb_valid   (csb2apb_valid),     //|< i
  .nvdla2csb_data    (csb2apb_data)       //|< i
);

assign csb2nvdla_valid = apb2csb_valid;
assign csb2nvdla_ready = apb2csb_ready;
assign csb2nvdla_addr = apb2csb_addr;
assign csb2nvdla_wdat = apb2csb_wdat;
assign csb2nvdla_write = apb2csb_write;
assign csb2nvdla_nposted = apb2csb_nposted;
assign nvdla2csb_valid = csb2apb_valid;
assign nvdla2csb_data = csb2apb_data;

// NVDLA
NV_nvdla nvdla_i ( 
  .dla_core_clk                  (dla_core_clk),                  //|< i
  .dla_csb_clk                   (dla_csb_clk),                  //|< i
  .global_clk_ovr_on             (global_clk_ovr_on),             //|< i
  .tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating), //|< i
  .dla_reset_rstn                (dla_reset_rstn),                //|< i
  .direct_reset_                 (direct_reset_),                 //|< i
  .test_mode                     (test_mode),                     //|< i

  .csb2nvdla_valid               (csb2nvdla_valid),               //|< i
  .csb2nvdla_ready               (csb2nvdla_ready),               //|> o
  .csb2nvdla_addr                (csb2nvdla_addr),                //|< i
  .csb2nvdla_wdat                (csb2nvdla_wdat),                //|< i
  .csb2nvdla_write               (csb2nvdla_write),               //|< i
  .csb2nvdla_nposted             (csb2nvdla_nposted),             //|< i
  .nvdla2csb_valid               (nvdla2csb_valid),               //|> o
  .nvdla2csb_data                (nvdla2csb_data),                //|> o
  .nvdla2csb_wr_complete         (nvdla2csb_wr_complete),         //|> o

  .nvdla_core2dbb_ar_awvalid     (dbb_ar_arvalid),                //|> o
  .nvdla_core2dbb_ar_awready     (dbb_ar_arready),                //|< i
  .nvdla_core2dbb_ar_awid        (dbb_ar_arid),                   //|> o
  .nvdla_core2dbb_ar_awlen       (dbb_ar_arlen),                  //|> o
  .nvdla_core2dbb_ar_awaddr      (dbb_ar_araddr),                 //|> o
  .nvdla_core2dbb_w_wvalid       (dbb_w_wvalid),                  //|> o
  .nvdla_core2dbb_w_wready       (dbb_w_wready),                  //|< i
  .nvdla_core2dbb_w_wdata        (dbb_w_wdata),                   //|> o
  .nvdla_core2dbb_w_wstrb        (dbb_w_wstrb),                   //|> o
  .nvdla_core2dbb_w_wlast        (dbb_w_wlast),                   //|> o
  .nvdla_core2dbb_b_bvalid       (dbb_b_bvalid),                  //|< i
  .nvdla_core2dbb_b_bready       (dbb_b_bready),                  //|> o
  .nvdla_core2dbb_b_bid          (dbb_b_bid),                     //|< i
  .nvdla_core2dbb_aw_awvalid     (dbb_aw_awvalid),                //|> o
  .nvdla_core2dbb_aw_awready     (dbb_aw_awready),                //|< i
  .nvdla_core2dbb_aw_awid        (dbb_aw_awid),                   //|> o
  .nvdla_core2dbb_aw_awlen       (dbb_aw_awlen),                  //|> o
  .nvdla_core2dbb_aw_awaddr      (dbb_aw_awaddr),                 //|> o
  .nvdla_core2dbb_r_rvalid       (dbb_r_rvalid),                  //|< i
  .nvdla_core2dbb_r_rready       (dbb_r_rready),                  //|> o
  .nvdla_core2dbb_r_rid          (dbb_r_rid),                     //|< i
  .nvdla_core2dbb_r_rlast        (dbb_r_rlast),                   //|< i
  .nvdla_core2dbb_r_rdata        (dbb_r_rdata),                   //|< i

  .dla_intr                      (dla_intr),                      //|> o

  .nvdla_pwrbus_ram_c_pd         (nvdla_pwrbus_ram_c_pd),         //|< i
  .nvdla_pwrbus_ram_ma_pd        (nvdla_pwrbus_ram_ma_pd),        //|< i *
  .nvdla_pwrbus_ram_mb_pd        (nvdla_pwrbus_ram_mb_pd),        //|< i *
  .nvdla_pwrbus_ram_p_pd         (nvdla_pwrbus_ram_p_pd),         //|< i
  .nvdla_pwrbus_ram_o_pd         (nvdla_pwrbus_ram_o_pd),         //|< i
  .nvdla_pwrbus_ram_a_pd         (nvdla_pwrbus_ram_a_pd)          //|< i
);

endmodule
