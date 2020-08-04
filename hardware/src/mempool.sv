// Copyright 2019 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

import mempool_pkg::*;

module mempool #(
    parameter int unsigned NumCores         = 1                         ,
    parameter int unsigned NumCoresPerTile  = 1                         ,
    parameter int unsigned BankingFactor    = 1                         ,
    // TCDM
    parameter addr_t TCDMBaseAddr           = 32'b0                     ,
    parameter int unsigned TCDMSizePerBank  = 1024 /* [B] */            ,
    // Boot address
    parameter logic [31:0] BootAddr         = 32'h0000_0000             ,
    // AXI
    parameter type axi_aw_t                 = logic                     ,
    parameter type axi_w_t                  = logic                     ,
    parameter type axi_b_t                  = logic                     ,
    parameter type axi_ar_t                 = logic                     ,
    parameter type axi_r_t                  = logic                     ,
    parameter type axi_req_t                = logic                     ,
    parameter type axi_resp_t               = logic                     ,
    // Dependent parameters. DO NOT CHANGE!
    parameter int unsigned NumTiles         = NumCores / NumCoresPerTile,
    parameter int unsigned NumBanks         = NumCores * BankingFactor  ,
    parameter int unsigned NumBanksPerTile  = NumBanks / NumTiles       ,
    parameter int unsigned TCDMAddrMemWidth = $clog2(TCDMSizePerBank / BeWidth)
  ) (
    // Clock and reset
    input  logic                     clk_i,
    input  logic                     rst_ni,
    // AXI Plugs for testbench
    output axi_req_t  [NumTiles-1:0] axi_mst_req_o,
    input  axi_resp_t [NumTiles-1:0] axi_mst_resp_i,
    // Scan chain
    input  logic                     scan_enable_i,
    input  logic                     scan_data_i,
    output logic                     scan_data_o
  );

  /*****************
   *  Definitions  *
   *****************/

  typedef logic [$clog2(NumTiles)-1:0] tile_id_t                            ;
  typedef logic [TCDMAddrMemWidth + $clog2(NumBanksPerTile)-1:0] tile_addr_t;

  /***********
   *  Tiles  *
   ***********/

  // Data interface

  logic          [NumCores-1:0] tcdm_master_req_valid;
  logic          [NumCores-1:0] tcdm_master_req_ready;
  addr_t         [NumCores-1:0] tcdm_master_req_tgt_addr;
  logic          [NumCores-1:0] tcdm_master_req_wen;
  tcdm_payload_t [NumCores-1:0] tcdm_master_req_wdata;
  strb_t         [NumCores-1:0] tcdm_master_req_be;
  tcdm_payload_t [NumCores-1:0] tcdm_master_resp_rdata;
  logic          [NumCores-1:0] tcdm_master_resp_valid;
  logic          [NumCores-1:0] tcdm_master_resp_ready;
  logic          [NumCores-1:0] tcdm_slave_req_valid;
  logic          [NumCores-1:0] tcdm_slave_req_ready;
  tile_addr_t    [NumCores-1:0] tcdm_slave_req_tgt_addr;
  tile_id_t      [NumCores-1:0] tcdm_slave_req_ini_addr;
  logic          [NumCores-1:0] tcdm_slave_req_wen;
  tcdm_payload_t [NumCores-1:0] tcdm_slave_req_wdata;
  strb_t         [NumCores-1:0] tcdm_slave_req_be;
  tile_id_t      [NumCores-1:0] tcdm_slave_resp_ini_addr;
  logic          [NumCores-1:0] tcdm_slave_resp_valid;
  logic          [NumCores-1:0] tcdm_slave_resp_ready;
  tcdm_payload_t [NumCores-1:0] tcdm_slave_resp_rdata;

  for (genvar t = 0; unsigned'(t) < NumTiles; t++) begin: gen_tiles

    mempool_tile #(
      .NumCoresPerTile(NumCoresPerTile),
      .NumBanksPerTile(NumBanksPerTile),
      .NumTiles       (NumTiles       ),
      .NumBanks       (NumBanks       ),
      .TCDMBaseAddr   (TCDMBaseAddr   ),
      .TCDMSizePerBank(TCDMSizePerBank),
      .BootAddr       (BootAddr       ),
      .axi_aw_t       (axi_aw_t       ),
      .axi_w_t        (axi_w_t        ),
      .axi_b_t        (axi_b_t        ),
      .axi_ar_t       (axi_ar_t       ),
      .axi_r_t        (axi_r_t        ),
      .axi_req_t      (axi_req_t      ),
      .axi_resp_t     (axi_resp_t     ),
      .tcdm_payload_t (tcdm_payload_t )
    ) i_tile (
      .clk_i                     (clk_i                                                         ),
      .rst_ni                    (rst_ni                                                        ),
      .scan_enable_i             (1'b0                                                          ),
      .scan_data_i               (1'b0                                                          ),
      .scan_data_o               (/* Unused */                                                  ),
      .tile_id_i                 (t[$clog2(NumTiles)-1:0]                                       ),
      // TCDM Master interfaces
      .tcdm_master_req_valid_o   (tcdm_master_req_valid[NumCoresPerTile*t +: NumCoresPerTile]   ),
      .tcdm_master_req_tgt_addr_o(tcdm_master_req_tgt_addr[NumCoresPerTile*t +: NumCoresPerTile]),
      .tcdm_master_req_wen_o     (tcdm_master_req_wen[NumCoresPerTile*t +: NumCoresPerTile]     ),
      .tcdm_master_req_wdata_o   (tcdm_master_req_wdata[NumCoresPerTile*t +: NumCoresPerTile]   ),
      .tcdm_master_req_be_o      (tcdm_master_req_be[NumCoresPerTile*t +: NumCoresPerTile]      ),
      .tcdm_master_req_ready_i   (tcdm_master_req_ready[NumCoresPerTile*t +: NumCoresPerTile]   ),
      .tcdm_master_resp_valid_i  (tcdm_master_resp_valid[NumCoresPerTile*t +: NumCoresPerTile]  ),
      .tcdm_master_resp_rdata_i  (tcdm_master_resp_rdata[NumCoresPerTile*t +: NumCoresPerTile]  ),
      // TCDM banks interface
      .tcdm_slave_req_valid_i    (tcdm_slave_req_valid[NumCoresPerTile*t +: NumCoresPerTile]    ),
      .tcdm_slave_req_ready_o    (tcdm_slave_req_ready[NumCoresPerTile*t +: NumCoresPerTile]    ),
      .tcdm_slave_req_tgt_addr_i (tcdm_slave_req_tgt_addr[NumCoresPerTile*t +: NumCoresPerTile] ),
      .tcdm_slave_req_be_i       (tcdm_slave_req_be[NumCoresPerTile*t +: NumCoresPerTile]       ),
      .tcdm_slave_req_wen_i      (tcdm_slave_req_wen[NumCoresPerTile*t +: NumCoresPerTile]      ),
      .tcdm_slave_req_wdata_i    (tcdm_slave_req_wdata[NumCoresPerTile*t +: NumCoresPerTile]    ),
      .tcdm_slave_req_ini_addr_i (tcdm_slave_req_ini_addr[NumCoresPerTile*t +: NumCoresPerTile] ),
      .tcdm_slave_resp_ini_addr_o(tcdm_slave_resp_ini_addr[NumCoresPerTile*t +: NumCoresPerTile]),
      .tcdm_slave_resp_rdata_o   (tcdm_slave_resp_rdata[NumCoresPerTile*t +: NumCoresPerTile]   ),
      .tcdm_slave_resp_valid_o   (tcdm_slave_resp_valid[NumCoresPerTile*t +: NumCoresPerTile]   ),
      .tcdm_slave_resp_ready_i   (tcdm_slave_resp_ready[NumCoresPerTile*t +: NumCoresPerTile]   ),
      // AXI interface
      .axi_mst_req_o             (axi_mst_req_o[t]                                              ),
      .axi_mst_resp_i            (axi_mst_resp_i[t]                                             ),
      // Instruction refill interface
      .refill_qaddr_o            (/* Not yet implemented */                                     ),
      .refill_qlen_o             (/* Not yet implemented */                                     ), // AXI signal
      .refill_qvalid_o           (/* Not yet implemented */                                     ),
      .refill_qready_i           (/* Not yet implemented */ 1'b0                                ),
      .refill_pdata_i            (/* Not yet implemented */ '0                                  ),
      .refill_perror_i           (/* Not yet implemented */ '0                                  ),
      .refill_pvalid_i           (/* Not yet implemented */ 1'b0                                ),
      .refill_plast_i            (/* Not yet implemented */ 1'b0                                ),
      .refill_pready_o           (/* Not yet implemented */                                     )
    );

    // Tile always accepts remote answers
    assign tcdm_master_resp_ready[NumCoresPerTile*t +: NumCoresPerTile] = {NumCoresPerTile{1'b1}};
  end : gen_tiles

  /*******************
   *  Interconnects  *
   *******************/

  logic          [NumCoresPerTile-1:0][NumTiles-1:0] master_req_valid ;
  logic          [NumCoresPerTile-1:0][NumTiles-1:0] master_req_ready ;
  addr_t         [NumCoresPerTile-1:0][NumTiles-1:0] master_req_tgt_addr ;
  logic          [NumCoresPerTile-1:0][NumTiles-1:0] master_req_wen ;
  tcdm_payload_t [NumCoresPerTile-1:0][NumTiles-1:0] master_req_wdata ;
  strb_t         [NumCoresPerTile-1:0][NumTiles-1:0] master_req_be ;
  tcdm_payload_t [NumCoresPerTile-1:0][NumTiles-1:0] master_resp_rdata;
  logic          [NumCoresPerTile-1:0][NumTiles-1:0] master_resp_valid ;
  logic          [NumCoresPerTile-1:0][NumTiles-1:0] master_resp_ready ;
  logic          [NumCoresPerTile-1:0][NumTiles-1:0] slave_req_valid ;
  logic          [NumCoresPerTile-1:0][NumTiles-1:0] slave_req_ready ;
  tile_addr_t    [NumCoresPerTile-1:0][NumTiles-1:0] slave_req_tgt_addr ;
  tile_id_t      [NumCoresPerTile-1:0][NumTiles-1:0] slave_req_ini_addr ;
  logic          [NumCoresPerTile-1:0][NumTiles-1:0] slave_req_wen ;
  tcdm_payload_t [NumCoresPerTile-1:0][NumTiles-1:0] slave_req_wdata ;
  strb_t         [NumCoresPerTile-1:0][NumTiles-1:0] slave_req_be ;
  tile_id_t      [NumCoresPerTile-1:0][NumTiles-1:0] slave_resp_ini_addr ;
  logic          [NumCoresPerTile-1:0][NumTiles-1:0] slave_resp_valid ;
  logic          [NumCoresPerTile-1:0][NumTiles-1:0] slave_resp_ready ;
  tcdm_payload_t [NumCoresPerTile-1:0][NumTiles-1:0] slave_resp_rdata ;

  for (genvar c = 0; c < NumCoresPerTile; c++) begin: gen_intercos

    for (genvar t = 0; t < NumTiles; t++) begin: gen_connections
      assign master_req_valid[c][t]                         = tcdm_master_req_valid[NumCoresPerTile*t + c]   ;
      assign master_req_tgt_addr[c][t]                      = tcdm_master_req_tgt_addr[NumCoresPerTile*t + c];
      assign master_req_wen[c][t]                           = tcdm_master_req_wen[NumCoresPerTile*t + c]     ;
      assign master_req_wdata[c][t]                         = tcdm_master_req_wdata[NumCoresPerTile*t + c]   ;
      assign master_req_be[c][t]                            = tcdm_master_req_be[NumCoresPerTile*t + c]      ;
      assign tcdm_master_req_ready[NumCoresPerTile*t + c]   = master_req_ready[c][t]                         ;
      assign tcdm_master_resp_valid[NumCoresPerTile*t + c]  = master_resp_valid[c][t]                        ;
      assign tcdm_master_resp_rdata[NumCoresPerTile*t + c]  = master_resp_rdata[c][t]                        ;
      assign master_resp_ready[c][t]                        = tcdm_master_resp_ready[NumCoresPerTile*t + c]  ;
      assign tcdm_slave_req_valid[NumCoresPerTile*t + c]    = slave_req_valid[c][t]                          ;
      assign tcdm_slave_req_tgt_addr[NumCoresPerTile*t + c] = slave_req_tgt_addr[c][t]                       ;
      assign tcdm_slave_req_ini_addr[NumCoresPerTile*t + c] = slave_req_ini_addr[c][t]                       ;
      assign tcdm_slave_req_wen[NumCoresPerTile*t + c]      = slave_req_wen[c][t]                            ;
      assign tcdm_slave_req_wdata[NumCoresPerTile*t + c]    = slave_req_wdata[c][t]                          ;
      assign tcdm_slave_req_be[NumCoresPerTile*t + c]       = slave_req_be[c][t]                             ;
      assign slave_req_ready[c][t]                          = tcdm_slave_req_ready[NumCoresPerTile*t + c]    ;
      assign slave_resp_valid[c][t]                         = tcdm_slave_resp_valid[NumCoresPerTile*t + c]   ;
      assign slave_resp_rdata[c][t]                         = tcdm_slave_resp_rdata[NumCoresPerTile*t + c]   ;
      assign slave_resp_ini_addr[c][t]                      = tcdm_slave_resp_ini_addr[NumCoresPerTile*t + c];
      assign tcdm_slave_resp_ready[NumCoresPerTile*t + c]   = slave_resp_ready[c][t]                         ;
    end: gen_connections

    // Interconnect
    variable_latency_interconnect #(
      .NumIn            (NumTiles                                  ),
      .NumOut           (NumTiles                                  ),
      .AddrWidth        (AddrWidth                                 ),
      .DataWidth        ($bits(tcdm_payload_t)                     ),
      .ByteOffWidth     (ByteOffset                                ),
      .AddrMemWidth     (TCDMAddrMemWidth + $clog2(NumBanksPerTile)),
      .Topology         (tcdm_interconnect_pkg::BFLY4              ),
      .SpillRegisterReq (64'b0101                                  ),
      .SpillRegisterResp(64'b0101                                  ),
      .AxiVldRdy        (1'b1                                      )
    ) i_interco (
      .clk_i          (clk_i                 ),
      .rst_ni         (rst_ni                ),
      .req_valid_i    (master_req_valid[c]   ),
      .req_ready_o    (master_req_ready[c]   ),
      .req_tgt_addr_i (master_req_tgt_addr[c]),
      .req_wen_i      (master_req_wen[c]     ),
      .req_wdata_i    (master_req_wdata[c]   ),
      .req_be_i       (master_req_be[c]      ),
      .resp_valid_o   (master_resp_valid[c]  ),
      .resp_ready_i   (master_resp_ready[c]  ),
      .resp_rdata_o   (master_resp_rdata[c]  ),
      .req_valid_o    (slave_req_valid[c]    ),
      .req_ready_i    (slave_req_ready[c]    ),
      .req_be_o       (slave_req_be[c]       ),
      .req_wdata_o    (slave_req_wdata[c]    ),
      .req_wen_o      (slave_req_wen[c]      ),
      .req_ini_addr_o (slave_req_ini_addr[c] ),
      .req_tgt_addr_o (slave_req_tgt_addr[c] ),
      .resp_ini_addr_i(slave_resp_ini_addr[c]),
      .resp_rdata_i   (slave_resp_rdata[c]   ),
      .resp_valid_i   (slave_resp_valid[c]   ),
      .resp_ready_o   (slave_resp_ready[c]   )
    );
  end

  /****************
   *  Assertions  *
   ****************/

  if (NumCores > 1024)
    $fatal(1, "[mempool] MemPool is currently limited to 1024 cores.");

  if (NumTiles <= 1)
    $fatal(1, "[mempool] MemPool requires at least two tiles.");

  if (NumCores != NumTiles * NumCoresPerTile)
    $fatal(1, "[mempool] The number of cores is not divisible by the number of cores per tile.");

  if (BankingFactor < 1)
    $fatal(1, "[mempool] The banking factor must be a positive integer.");

  if (BankingFactor != 2**$clog2(BankingFactor))
    $fatal(1, "[mempool] The banking factor must be a power of two.");

endmodule : mempool