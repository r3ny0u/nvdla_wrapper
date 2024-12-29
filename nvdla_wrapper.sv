module nvdla_wrapper (
  // Clock
  ,dla_core_clk                       //|< i
  ,dla_csb_clk                        //|< i
  ,global_clk_ovr_on                  //|< i
  ,tmc2slcg_disable_clock_gating      //|< i
  ,pclk                               //|< i

  // Reset
  ,dla_reset_rstn                     //|< i
  ,direct_reset_                      //|< i
  ,prstn                              //|< i

  // Test mode
  ,test_mode                          //|< i

  // APB
  ,psel                               //|< i
  ,penable                            //|< i
  ,pwrite                             //|< i
  ,paddr                              //|< i
  ,pwdata                             //|< i
  ,prdata                             //|> o
  ,pready                             //|> o

  // AXI
  ,dbb_aw_awvalid                     //|> o
  ,dbb_aw_awready                     //|< i
  ,dbb_aw_awid                        //|> o
  ,dbb_aw_awlen                       //|> o
  ,dbb_aw_awaddr                      //|> o
  
  ,dbb_w_wvalid                       //|> o
  ,dbb_w_wready                       //|< i
  ,dbb_w_wdata                        //|> o
  ,dbb_w_wstrb                        //|> o
  ,dbb_w_wlast                        //|> o

  ,dbb_b_bvalid                       //|< i
  ,dbb_b_bready                       //|> o
  ,dbb_b_bid                          //|< i

  ,dbb_ar_arvalid                     //|> o
  ,dbb_ar_arready                     //|< i
  ,dbb_ar_arid                        //|> o
  ,dbb_ar_arlen                       //|> o
  ,dbb_ar_araddr                      //|> o

  ,dbb_r_rvalid                       //|< i
  ,dbb_r_rready                       //|> o
  ,dbb_r_rid                          //|< i
  ,dbb_r_rlast                        //|< i
  ,dbb_r_rdata                        //|< i

  // Interrupt
  ,dla_intr                           //|> o
);

  // Clock
  input  dla_core_clk;
  input  dla_csb_clk;
  input  global_clk_ovr_on;
  input  tmc2slcg_disable_clock_gating;

  // Reset
  input  dla_reset_rstn;
  input  direct_reset_;

  // Test mode
  input  test_mode;

  // APB
  input pclk;
  input prstn;
  input psel;
  input penable;
  input pwrite;
  input [31:0] paddr;
  input [31:0] pwdata;
  output [31:0] prdata;
  output pready;

  // APB to CSB
  output apb2csb_valid;
  input  apb2csb_ready;
  output [15:0] apb2csb_addr;
  output [31:0] apb2csb_wdat;
  output apb2csb_write;
  output apb2csb_nposted;
  input  csb2apb_valid;
  input [31:0] csb2apb_data;

  // CSB to NVDLA
  input  csb2nvdla_valid;
  output csb2nvdla_ready;
  input  [15:0] csb2nvdla_addr;
  input  [31:0] csb2nvdla_wdat;
  input  csb2nvdla_write;
  input  csb2nvdla_nposted;
  output nvdla2csb_valid;
  output [31:0] nvdla2csb_data;
  output nvdla2csb_wr_complete;

  // AXI
  output dbb_aw_awvalid;
  input  dbb_aw_awready;
  output [7:0] dbb_aw_awid;
  output [3:0] dbb_aw_awlen;
  output [63:0] dbb_aw_awaddr;
  
  output dbb_w_wvalid;
  input  dbb_w_wready;
  output [511:0] dbb_w_wdata;
  output [63:0] dbb_w_wstrb;
  output dbb_w_wlast;

  input  dbb_b_bvalid;
  output dbb_b_bready;
  input  [7:0] dbb_b_bid;

  output dbb_ar_arvalid;
  input  dbb_ar_arready;
  output [7:0] dbb_ar_arid;
  output [3:0] dbb_ar_arlen;
  output [63:0] dbb_ar_araddr;

  input  dbb_r_rvalid;
  output dbb_r_rready;
  input  [7:0] dbb_r_rid;
  input  dbb_r_rlast;
  input  [511:0] dbb_r_rdata;

  // Interrupt
  output dla_intr;
  output dla_intr,

  // Power bus
  input  [31:0] nvdla_pwrbus_ram_c_pd,
  input  [31:0] nvdla_pwrbus_ram_ma_pd,
  input  [31:0] nvdla_pwrbus_ram_mb_pd,
  input  [31:0] nvdla_pwrbus_ram_p_pd,
  input  [31:0] nvdla_pwrbus_ram_o_pd,
  input  [31:0] nvdla_pwrbus_ram_a_pd

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
  .nvdla_core2dbb_r_rdata        (dbb_r_rdata)                    //|< i

  .dla_intr                      (dla_intr),                      //|> o

  .nvdla_pwrbus_ram_c_pd         (nvdla_pwrbus_ram_c_pd),         //|< i
  .nvdla_pwrbus_ram_ma_pd        (nvdla_pwrbus_ram_ma_pd),        //|< i *
  .nvdla_pwrbus_ram_mb_pd        (nvdla_pwrbus_ram_mb_pd),        //|< i *
  .nvdla_pwrbus_ram_p_pd         (nvdla_pwrbus_ram_p_pd),         //|< i
  .nvdla_pwrbus_ram_o_pd         (nvdla_pwrbus_ram_o_pd),         //|< i
  .nvdla_pwrbus_ram_a_pd         (nvdla_pwrbus_ram_a_pd)          //|< i
);

endmodule
