// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Register Top module auto-generated by `reggen`


`include "common_cells/assertions.svh"

module control_registers_reg_top #(
  parameter type reg_req_t = logic,
  parameter type reg_rsp_t = logic,
  parameter int AW = 7
) (
  input logic clk_i,
  input logic rst_ni,
  input  reg_req_t reg_req_i,
  output reg_rsp_t reg_rsp_o,
  // To HW
  output control_registers_reg_pkg::control_registers_reg2hw_t reg2hw, // Write
  input  control_registers_reg_pkg::control_registers_hw2reg_t hw2reg, // Read


  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import control_registers_reg_pkg::* ;

  localparam int DW = 32;
  localparam int DBW = DW/8;                    // Byte Width

  // register signals
  logic           reg_we;
  logic           reg_re;
  logic [BlockAw-1:0]  reg_addr;
  logic [DW-1:0]  reg_wdata;
  logic [DBW-1:0] reg_be;
  logic [DW-1:0]  reg_rdata;
  logic           reg_error;

  logic          addrmiss, wr_err;

  logic [DW-1:0] reg_rdata_next;

  // Below register interface can be changed
  reg_req_t  reg_intf_req;
  reg_rsp_t  reg_intf_rsp;


  assign reg_intf_req = reg_req_i;
  assign reg_rsp_o = reg_intf_rsp;


  assign reg_we = reg_intf_req.valid & reg_intf_req.write;
  assign reg_re = reg_intf_req.valid & ~reg_intf_req.write;
  assign reg_addr = reg_intf_req.addr[BlockAw-1:0];
  assign reg_wdata = reg_intf_req.wdata;
  assign reg_be = reg_intf_req.wstrb;
  assign reg_intf_rsp.rdata = reg_rdata;
  assign reg_intf_rsp.error = reg_error;
  assign reg_intf_rsp.ready = 1'b1;

  assign reg_rdata = reg_rdata_next ;
  assign reg_error = (devmode_i & addrmiss) | wr_err;


  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic [31:0] eoc_qs;
  logic [31:0] eoc_wd;
  logic eoc_we;
  logic [31:0] wake_up_wd;
  logic wake_up_we;
  logic [31:0] wake_up_tile_0_wd;
  logic wake_up_tile_0_we;
  logic [31:0] wake_up_tile_1_wd;
  logic wake_up_tile_1_we;
  logic [31:0] wake_up_tile_2_wd;
  logic wake_up_tile_2_we;
  logic [31:0] wake_up_tile_3_wd;
  logic wake_up_tile_3_we;
  logic [31:0] wake_up_tile_4_wd;
  logic wake_up_tile_4_we;
  logic [31:0] wake_up_tile_5_wd;
  logic wake_up_tile_5_we;
  logic [31:0] wake_up_tile_6_wd;
  logic wake_up_tile_6_we;
  logic [31:0] wake_up_tile_7_wd;
  logic wake_up_tile_7_we;
  logic [31:0] wake_up_group_wd;
  logic wake_up_group_we;
  logic [31:0] wake_up_strd_wd;
  logic wake_up_strd_we;
  logic [31:0] wake_up_offst_wd;
  logic wake_up_offst_we;
  logic [31:0] tcdm_start_address_qs;
  logic tcdm_start_address_re;
  logic [31:0] tcdm_end_address_qs;
  logic tcdm_end_address_re;
  logic [31:0] nr_cores_reg_qs;
  logic nr_cores_reg_re;
  logic [31:0] ro_cache_enable_qs;
  logic [31:0] ro_cache_enable_wd;
  logic ro_cache_enable_we;
  logic [31:0] ro_cache_flush_qs;
  logic [31:0] ro_cache_flush_wd;
  logic ro_cache_flush_we;
  logic [31:0] ro_cache_start_0_qs;
  logic [31:0] ro_cache_start_0_wd;
  logic ro_cache_start_0_we;
  logic ro_cache_start_0_re;
  logic [31:0] ro_cache_start_1_qs;
  logic [31:0] ro_cache_start_1_wd;
  logic ro_cache_start_1_we;
  logic ro_cache_start_1_re;
  logic [31:0] ro_cache_start_2_qs;
  logic [31:0] ro_cache_start_2_wd;
  logic ro_cache_start_2_we;
  logic ro_cache_start_2_re;
  logic [31:0] ro_cache_start_3_qs;
  logic [31:0] ro_cache_start_3_wd;
  logic ro_cache_start_3_we;
  logic ro_cache_start_3_re;
  logic [31:0] ro_cache_end_0_qs;
  logic [31:0] ro_cache_end_0_wd;
  logic ro_cache_end_0_we;
  logic ro_cache_end_0_re;
  logic [31:0] ro_cache_end_1_qs;
  logic [31:0] ro_cache_end_1_wd;
  logic ro_cache_end_1_we;
  logic ro_cache_end_1_re;
  logic [31:0] ro_cache_end_2_qs;
  logic [31:0] ro_cache_end_2_wd;
  logic ro_cache_end_2_we;
  logic ro_cache_end_2_re;
  logic [31:0] ro_cache_end_3_qs;
  logic [31:0] ro_cache_end_3_wd;
  logic ro_cache_end_3_we;
  logic ro_cache_end_3_re;

  // Register instances
  // R[eoc]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_eoc (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (eoc_we),
    .wd     (eoc_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.eoc.q ),

    // to register interface (read)
    .qs     (eoc_qs)
  );


  // R[wake_up]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("WO"),
    .RESVAL  (32'h0)
  ) u_wake_up (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (wake_up_we),
    .wd     (wake_up_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.wake_up.qe),
    .q      (reg2hw.wake_up.q ),

    .qs     ()
  );



  // Subregister 0 of Multireg wake_up_tile
  // R[wake_up_tile_0]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("WO"),
    .RESVAL  (32'h0)
  ) u_wake_up_tile_0 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (wake_up_tile_0_we),
    .wd     (wake_up_tile_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.wake_up_tile[0].qe),
    .q      (reg2hw.wake_up_tile[0].q ),

    .qs     ()
  );

  // Subregister 1 of Multireg wake_up_tile
  // R[wake_up_tile_1]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("WO"),
    .RESVAL  (32'h0)
  ) u_wake_up_tile_1 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (wake_up_tile_1_we),
    .wd     (wake_up_tile_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.wake_up_tile[1].qe),
    .q      (reg2hw.wake_up_tile[1].q ),

    .qs     ()
  );

  // Subregister 2 of Multireg wake_up_tile
  // R[wake_up_tile_2]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("WO"),
    .RESVAL  (32'h0)
  ) u_wake_up_tile_2 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (wake_up_tile_2_we),
    .wd     (wake_up_tile_2_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.wake_up_tile[2].qe),
    .q      (reg2hw.wake_up_tile[2].q ),

    .qs     ()
  );

  // Subregister 3 of Multireg wake_up_tile
  // R[wake_up_tile_3]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("WO"),
    .RESVAL  (32'h0)
  ) u_wake_up_tile_3 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (wake_up_tile_3_we),
    .wd     (wake_up_tile_3_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.wake_up_tile[3].qe),
    .q      (reg2hw.wake_up_tile[3].q ),

    .qs     ()
  );

  // Subregister 4 of Multireg wake_up_tile
  // R[wake_up_tile_4]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("WO"),
    .RESVAL  (32'h0)
  ) u_wake_up_tile_4 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (wake_up_tile_4_we),
    .wd     (wake_up_tile_4_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.wake_up_tile[4].qe),
    .q      (reg2hw.wake_up_tile[4].q ),

    .qs     ()
  );

  // Subregister 5 of Multireg wake_up_tile
  // R[wake_up_tile_5]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("WO"),
    .RESVAL  (32'h0)
  ) u_wake_up_tile_5 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (wake_up_tile_5_we),
    .wd     (wake_up_tile_5_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.wake_up_tile[5].qe),
    .q      (reg2hw.wake_up_tile[5].q ),

    .qs     ()
  );

  // Subregister 6 of Multireg wake_up_tile
  // R[wake_up_tile_6]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("WO"),
    .RESVAL  (32'h0)
  ) u_wake_up_tile_6 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (wake_up_tile_6_we),
    .wd     (wake_up_tile_6_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.wake_up_tile[6].qe),
    .q      (reg2hw.wake_up_tile[6].q ),

    .qs     ()
  );

  // Subregister 7 of Multireg wake_up_tile
  // R[wake_up_tile_7]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("WO"),
    .RESVAL  (32'h0)
  ) u_wake_up_tile_7 (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (wake_up_tile_7_we),
    .wd     (wake_up_tile_7_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.wake_up_tile[7].qe),
    .q      (reg2hw.wake_up_tile[7].q ),

    .qs     ()
  );


  // R[wake_up_group]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("WO"),
    .RESVAL  (32'h0)
  ) u_wake_up_group (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (wake_up_group_we),
    .wd     (wake_up_group_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.wake_up_group.qe),
    .q      (reg2hw.wake_up_group.q ),

    .qs     ()
  );


  // R[wake_up_strd]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("WO"),
    .RESVAL  (32'h0)
  ) u_wake_up_strd (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (wake_up_strd_we),
    .wd     (wake_up_strd_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.wake_up_strd.qe),
    .q      (reg2hw.wake_up_strd.q ),

    .qs     ()
  );


  // R[wake_up_offst]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("WO"),
    .RESVAL  (32'h0)
  ) u_wake_up_offst (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (wake_up_offst_we),
    .wd     (wake_up_offst_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (reg2hw.wake_up_offst.qe),
    .q      (reg2hw.wake_up_offst.q ),

    .qs     ()
  );


  // R[tcdm_start_address]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_tcdm_start_address (
    .re     (tcdm_start_address_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.tcdm_start_address.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (tcdm_start_address_qs)
  );


  // R[tcdm_end_address]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_tcdm_end_address (
    .re     (tcdm_end_address_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.tcdm_end_address.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (tcdm_end_address_qs)
  );


  // R[nr_cores_reg]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_nr_cores_reg (
    .re     (nr_cores_reg_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.nr_cores_reg.d),
    .qre    (),
    .qe     (),
    .q      (),
    .qs     (nr_cores_reg_qs)
  );


  // R[ro_cache_enable]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h1)
  ) u_ro_cache_enable (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (ro_cache_enable_we),
    .wd     (ro_cache_enable_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ro_cache_enable.q ),

    // to register interface (read)
    .qs     (ro_cache_enable_qs)
  );


  // R[ro_cache_flush]: V(False)

  prim_subreg #(
    .DW      (32),
    .SWACCESS("RW"),
    .RESVAL  (32'h0)
  ) u_ro_cache_flush (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (ro_cache_flush_we),
    .wd     (ro_cache_flush_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0  ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.ro_cache_flush.q ),

    // to register interface (read)
    .qs     (ro_cache_flush_qs)
  );



  // Subregister 0 of Multireg ro_cache_start
  // R[ro_cache_start_0]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_ro_cache_start_0 (
    .re     (ro_cache_start_0_re),
    .we     (ro_cache_start_0_we),
    .wd     (ro_cache_start_0_wd),
    .d      (hw2reg.ro_cache_start[0].d),
    .qre    (),
    .qe     (reg2hw.ro_cache_start[0].qe),
    .q      (reg2hw.ro_cache_start[0].q ),
    .qs     (ro_cache_start_0_qs)
  );

  // Subregister 1 of Multireg ro_cache_start
  // R[ro_cache_start_1]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_ro_cache_start_1 (
    .re     (ro_cache_start_1_re),
    .we     (ro_cache_start_1_we),
    .wd     (ro_cache_start_1_wd),
    .d      (hw2reg.ro_cache_start[1].d),
    .qre    (),
    .qe     (reg2hw.ro_cache_start[1].qe),
    .q      (reg2hw.ro_cache_start[1].q ),
    .qs     (ro_cache_start_1_qs)
  );

  // Subregister 2 of Multireg ro_cache_start
  // R[ro_cache_start_2]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_ro_cache_start_2 (
    .re     (ro_cache_start_2_re),
    .we     (ro_cache_start_2_we),
    .wd     (ro_cache_start_2_wd),
    .d      (hw2reg.ro_cache_start[2].d),
    .qre    (),
    .qe     (reg2hw.ro_cache_start[2].qe),
    .q      (reg2hw.ro_cache_start[2].q ),
    .qs     (ro_cache_start_2_qs)
  );

  // Subregister 3 of Multireg ro_cache_start
  // R[ro_cache_start_3]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_ro_cache_start_3 (
    .re     (ro_cache_start_3_re),
    .we     (ro_cache_start_3_we),
    .wd     (ro_cache_start_3_wd),
    .d      (hw2reg.ro_cache_start[3].d),
    .qre    (),
    .qe     (reg2hw.ro_cache_start[3].qe),
    .q      (reg2hw.ro_cache_start[3].q ),
    .qs     (ro_cache_start_3_qs)
  );



  // Subregister 0 of Multireg ro_cache_end
  // R[ro_cache_end_0]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_ro_cache_end_0 (
    .re     (ro_cache_end_0_re),
    .we     (ro_cache_end_0_we),
    .wd     (ro_cache_end_0_wd),
    .d      (hw2reg.ro_cache_end[0].d),
    .qre    (),
    .qe     (reg2hw.ro_cache_end[0].qe),
    .q      (reg2hw.ro_cache_end[0].q ),
    .qs     (ro_cache_end_0_qs)
  );

  // Subregister 1 of Multireg ro_cache_end
  // R[ro_cache_end_1]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_ro_cache_end_1 (
    .re     (ro_cache_end_1_re),
    .we     (ro_cache_end_1_we),
    .wd     (ro_cache_end_1_wd),
    .d      (hw2reg.ro_cache_end[1].d),
    .qre    (),
    .qe     (reg2hw.ro_cache_end[1].qe),
    .q      (reg2hw.ro_cache_end[1].q ),
    .qs     (ro_cache_end_1_qs)
  );

  // Subregister 2 of Multireg ro_cache_end
  // R[ro_cache_end_2]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_ro_cache_end_2 (
    .re     (ro_cache_end_2_re),
    .we     (ro_cache_end_2_we),
    .wd     (ro_cache_end_2_wd),
    .d      (hw2reg.ro_cache_end[2].d),
    .qre    (),
    .qe     (reg2hw.ro_cache_end[2].qe),
    .q      (reg2hw.ro_cache_end[2].q ),
    .qs     (ro_cache_end_2_qs)
  );

  // Subregister 3 of Multireg ro_cache_end
  // R[ro_cache_end_3]: V(True)

  prim_subreg_ext #(
    .DW    (32)
  ) u_ro_cache_end_3 (
    .re     (ro_cache_end_3_re),
    .we     (ro_cache_end_3_we),
    .wd     (ro_cache_end_3_wd),
    .d      (hw2reg.ro_cache_end[3].d),
    .qre    (),
    .qe     (reg2hw.ro_cache_end[3].qe),
    .q      (reg2hw.ro_cache_end[3].q ),
    .qs     (ro_cache_end_3_qs)
  );




  logic [25:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == CONTROL_REGISTERS_EOC_OFFSET);
    addr_hit[ 1] = (reg_addr == CONTROL_REGISTERS_WAKE_UP_OFFSET);
    addr_hit[ 2] = (reg_addr == CONTROL_REGISTERS_WAKE_UP_TILE_0_OFFSET);
    addr_hit[ 3] = (reg_addr == CONTROL_REGISTERS_WAKE_UP_TILE_1_OFFSET);
    addr_hit[ 4] = (reg_addr == CONTROL_REGISTERS_WAKE_UP_TILE_2_OFFSET);
    addr_hit[ 5] = (reg_addr == CONTROL_REGISTERS_WAKE_UP_TILE_3_OFFSET);
    addr_hit[ 6] = (reg_addr == CONTROL_REGISTERS_WAKE_UP_TILE_4_OFFSET);
    addr_hit[ 7] = (reg_addr == CONTROL_REGISTERS_WAKE_UP_TILE_5_OFFSET);
    addr_hit[ 8] = (reg_addr == CONTROL_REGISTERS_WAKE_UP_TILE_6_OFFSET);
    addr_hit[ 9] = (reg_addr == CONTROL_REGISTERS_WAKE_UP_TILE_7_OFFSET);
    addr_hit[10] = (reg_addr == CONTROL_REGISTERS_WAKE_UP_GROUP_OFFSET);
    addr_hit[11] = (reg_addr == CONTROL_REGISTERS_WAKE_UP_STRD_OFFSET);
    addr_hit[12] = (reg_addr == CONTROL_REGISTERS_WAKE_UP_OFFST_OFFSET);
    addr_hit[13] = (reg_addr == CONTROL_REGISTERS_TCDM_START_ADDRESS_OFFSET);
    addr_hit[14] = (reg_addr == CONTROL_REGISTERS_TCDM_END_ADDRESS_OFFSET);
    addr_hit[15] = (reg_addr == CONTROL_REGISTERS_NR_CORES_REG_OFFSET);
    addr_hit[16] = (reg_addr == CONTROL_REGISTERS_RO_CACHE_ENABLE_OFFSET);
    addr_hit[17] = (reg_addr == CONTROL_REGISTERS_RO_CACHE_FLUSH_OFFSET);
    addr_hit[18] = (reg_addr == CONTROL_REGISTERS_RO_CACHE_START_0_OFFSET);
    addr_hit[19] = (reg_addr == CONTROL_REGISTERS_RO_CACHE_START_1_OFFSET);
    addr_hit[20] = (reg_addr == CONTROL_REGISTERS_RO_CACHE_START_2_OFFSET);
    addr_hit[21] = (reg_addr == CONTROL_REGISTERS_RO_CACHE_START_3_OFFSET);
    addr_hit[22] = (reg_addr == CONTROL_REGISTERS_RO_CACHE_END_0_OFFSET);
    addr_hit[23] = (reg_addr == CONTROL_REGISTERS_RO_CACHE_END_1_OFFSET);
    addr_hit[24] = (reg_addr == CONTROL_REGISTERS_RO_CACHE_END_2_OFFSET);
    addr_hit[25] = (reg_addr == CONTROL_REGISTERS_RO_CACHE_END_3_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((addr_hit[ 0] & (|(CONTROL_REGISTERS_PERMIT[ 0] & ~reg_be))) |
               (addr_hit[ 1] & (|(CONTROL_REGISTERS_PERMIT[ 1] & ~reg_be))) |
               (addr_hit[ 2] & (|(CONTROL_REGISTERS_PERMIT[ 2] & ~reg_be))) |
               (addr_hit[ 3] & (|(CONTROL_REGISTERS_PERMIT[ 3] & ~reg_be))) |
               (addr_hit[ 4] & (|(CONTROL_REGISTERS_PERMIT[ 4] & ~reg_be))) |
               (addr_hit[ 5] & (|(CONTROL_REGISTERS_PERMIT[ 5] & ~reg_be))) |
               (addr_hit[ 6] & (|(CONTROL_REGISTERS_PERMIT[ 6] & ~reg_be))) |
               (addr_hit[ 7] & (|(CONTROL_REGISTERS_PERMIT[ 7] & ~reg_be))) |
               (addr_hit[ 8] & (|(CONTROL_REGISTERS_PERMIT[ 8] & ~reg_be))) |
               (addr_hit[ 9] & (|(CONTROL_REGISTERS_PERMIT[ 9] & ~reg_be))) |
               (addr_hit[10] & (|(CONTROL_REGISTERS_PERMIT[10] & ~reg_be))) |
               (addr_hit[11] & (|(CONTROL_REGISTERS_PERMIT[11] & ~reg_be))) |
               (addr_hit[12] & (|(CONTROL_REGISTERS_PERMIT[12] & ~reg_be))) |
               (addr_hit[13] & (|(CONTROL_REGISTERS_PERMIT[13] & ~reg_be))) |
               (addr_hit[14] & (|(CONTROL_REGISTERS_PERMIT[14] & ~reg_be))) |
               (addr_hit[15] & (|(CONTROL_REGISTERS_PERMIT[15] & ~reg_be))) |
               (addr_hit[16] & (|(CONTROL_REGISTERS_PERMIT[16] & ~reg_be))) |
               (addr_hit[17] & (|(CONTROL_REGISTERS_PERMIT[17] & ~reg_be))) |
               (addr_hit[18] & (|(CONTROL_REGISTERS_PERMIT[18] & ~reg_be))) |
               (addr_hit[19] & (|(CONTROL_REGISTERS_PERMIT[19] & ~reg_be))) |
               (addr_hit[20] & (|(CONTROL_REGISTERS_PERMIT[20] & ~reg_be))) |
               (addr_hit[21] & (|(CONTROL_REGISTERS_PERMIT[21] & ~reg_be))) |
               (addr_hit[22] & (|(CONTROL_REGISTERS_PERMIT[22] & ~reg_be))) |
               (addr_hit[23] & (|(CONTROL_REGISTERS_PERMIT[23] & ~reg_be))) |
               (addr_hit[24] & (|(CONTROL_REGISTERS_PERMIT[24] & ~reg_be))) |
               (addr_hit[25] & (|(CONTROL_REGISTERS_PERMIT[25] & ~reg_be)))));
  end

  assign eoc_we = addr_hit[0] & reg_we & !reg_error;
  assign eoc_wd = reg_wdata[31:0];

  assign wake_up_we = addr_hit[1] & reg_we & !reg_error;
  assign wake_up_wd = reg_wdata[31:0];

  assign wake_up_tile_0_we = addr_hit[2] & reg_we & !reg_error;
  assign wake_up_tile_0_wd = reg_wdata[31:0];

  assign wake_up_tile_1_we = addr_hit[3] & reg_we & !reg_error;
  assign wake_up_tile_1_wd = reg_wdata[31:0];

  assign wake_up_tile_2_we = addr_hit[4] & reg_we & !reg_error;
  assign wake_up_tile_2_wd = reg_wdata[31:0];

  assign wake_up_tile_3_we = addr_hit[5] & reg_we & !reg_error;
  assign wake_up_tile_3_wd = reg_wdata[31:0];

  assign wake_up_tile_4_we = addr_hit[6] & reg_we & !reg_error;
  assign wake_up_tile_4_wd = reg_wdata[31:0];

  assign wake_up_tile_5_we = addr_hit[7] & reg_we & !reg_error;
  assign wake_up_tile_5_wd = reg_wdata[31:0];

  assign wake_up_tile_6_we = addr_hit[8] & reg_we & !reg_error;
  assign wake_up_tile_6_wd = reg_wdata[31:0];

  assign wake_up_tile_7_we = addr_hit[9] & reg_we & !reg_error;
  assign wake_up_tile_7_wd = reg_wdata[31:0];

  assign wake_up_group_we = addr_hit[10] & reg_we & !reg_error;
  assign wake_up_group_wd = reg_wdata[31:0];

  assign wake_up_strd_we = addr_hit[11] & reg_we & !reg_error;
  assign wake_up_strd_wd = reg_wdata[31:0];

  assign wake_up_offst_we = addr_hit[12] & reg_we & !reg_error;
  assign wake_up_offst_wd = reg_wdata[31:0];

  assign tcdm_start_address_re = addr_hit[13] & reg_re & !reg_error;

  assign tcdm_end_address_re = addr_hit[14] & reg_re & !reg_error;

  assign nr_cores_reg_re = addr_hit[15] & reg_re & !reg_error;

  assign ro_cache_enable_we = addr_hit[16] & reg_we & !reg_error;
  assign ro_cache_enable_wd = reg_wdata[31:0];

  assign ro_cache_flush_we = addr_hit[17] & reg_we & !reg_error;
  assign ro_cache_flush_wd = reg_wdata[31:0];

  assign ro_cache_start_0_we = addr_hit[18] & reg_we & !reg_error;
  assign ro_cache_start_0_wd = reg_wdata[31:0];
  assign ro_cache_start_0_re = addr_hit[18] & reg_re & !reg_error;

  assign ro_cache_start_1_we = addr_hit[19] & reg_we & !reg_error;
  assign ro_cache_start_1_wd = reg_wdata[31:0];
  assign ro_cache_start_1_re = addr_hit[19] & reg_re & !reg_error;

  assign ro_cache_start_2_we = addr_hit[20] & reg_we & !reg_error;
  assign ro_cache_start_2_wd = reg_wdata[31:0];
  assign ro_cache_start_2_re = addr_hit[20] & reg_re & !reg_error;

  assign ro_cache_start_3_we = addr_hit[21] & reg_we & !reg_error;
  assign ro_cache_start_3_wd = reg_wdata[31:0];
  assign ro_cache_start_3_re = addr_hit[21] & reg_re & !reg_error;

  assign ro_cache_end_0_we = addr_hit[22] & reg_we & !reg_error;
  assign ro_cache_end_0_wd = reg_wdata[31:0];
  assign ro_cache_end_0_re = addr_hit[22] & reg_re & !reg_error;

  assign ro_cache_end_1_we = addr_hit[23] & reg_we & !reg_error;
  assign ro_cache_end_1_wd = reg_wdata[31:0];
  assign ro_cache_end_1_re = addr_hit[23] & reg_re & !reg_error;

  assign ro_cache_end_2_we = addr_hit[24] & reg_we & !reg_error;
  assign ro_cache_end_2_wd = reg_wdata[31:0];
  assign ro_cache_end_2_re = addr_hit[24] & reg_re & !reg_error;

  assign ro_cache_end_3_we = addr_hit[25] & reg_we & !reg_error;
  assign ro_cache_end_3_wd = reg_wdata[31:0];
  assign ro_cache_end_3_re = addr_hit[25] & reg_re & !reg_error;

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[31:0] = eoc_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[2]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[3]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[4]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[5]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[6]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[7]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[8]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[9]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[10]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[11]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[12]: begin
        reg_rdata_next[31:0] = '0;
      end

      addr_hit[13]: begin
        reg_rdata_next[31:0] = tcdm_start_address_qs;
      end

      addr_hit[14]: begin
        reg_rdata_next[31:0] = tcdm_end_address_qs;
      end

      addr_hit[15]: begin
        reg_rdata_next[31:0] = nr_cores_reg_qs;
      end

      addr_hit[16]: begin
        reg_rdata_next[31:0] = ro_cache_enable_qs;
      end

      addr_hit[17]: begin
        reg_rdata_next[31:0] = ro_cache_flush_qs;
      end

      addr_hit[18]: begin
        reg_rdata_next[31:0] = ro_cache_start_0_qs;
      end

      addr_hit[19]: begin
        reg_rdata_next[31:0] = ro_cache_start_1_qs;
      end

      addr_hit[20]: begin
        reg_rdata_next[31:0] = ro_cache_start_2_qs;
      end

      addr_hit[21]: begin
        reg_rdata_next[31:0] = ro_cache_start_3_qs;
      end

      addr_hit[22]: begin
        reg_rdata_next[31:0] = ro_cache_end_0_qs;
      end

      addr_hit[23]: begin
        reg_rdata_next[31:0] = ro_cache_end_1_qs;
      end

      addr_hit[24]: begin
        reg_rdata_next[31:0] = ro_cache_end_2_qs;
      end

      addr_hit[25]: begin
        reg_rdata_next[31:0] = ro_cache_end_3_qs;
      end

      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // Unused signal tieoff

  // wdata / byte enable are not always fully used
  // add a blanket unused statement to handle lint waivers
  logic unused_wdata;
  logic unused_be;
  assign unused_wdata = ^reg_wdata;
  assign unused_be = ^reg_be;

  // Assertions for Register Interface
  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit))

endmodule

/* verilator lint_off DECLFILENAME */
module control_registers_reg_top_intf
#(
  parameter int AW = 7,
  localparam int DW = 32
) (
  input logic clk_i,
  input logic rst_ni,
  REG_BUS.in  regbus_slave,
  // To HW
  output control_registers_reg_pkg::control_registers_reg2hw_t reg2hw, // Write
  input  control_registers_reg_pkg::control_registers_hw2reg_t hw2reg, // Read
  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);
 localparam int unsigned STRB_WIDTH = DW/8;

`include "register_interface/typedef.svh"
`include "register_interface/assign.svh"

  // Define structs for reg_bus
  typedef logic [AW-1:0] addr_t;
  typedef logic [DW-1:0] data_t;
  typedef logic [STRB_WIDTH-1:0] strb_t;
  `REG_BUS_TYPEDEF_ALL(reg_bus, addr_t, data_t, strb_t)

  reg_bus_req_t s_reg_req;
  reg_bus_rsp_t s_reg_rsp;

  // Assign SV interface to structs
  `REG_BUS_ASSIGN_TO_REQ(s_reg_req, regbus_slave)
  `REG_BUS_ASSIGN_FROM_RSP(regbus_slave, s_reg_rsp)



  control_registers_reg_top #(
    .reg_req_t(reg_bus_req_t),
    .reg_rsp_t(reg_bus_rsp_t),
    .AW(AW)
  ) i_regs (
    .clk_i,
    .rst_ni,
    .reg_req_i(s_reg_req),
    .reg_rsp_o(s_reg_rsp),
    .reg2hw, // Write
    .hw2reg, // Read
    .devmode_i
  );

endmodule
/* verilator lint_on DECLFILENAME */
