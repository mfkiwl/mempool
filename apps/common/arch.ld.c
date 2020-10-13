/* This file will get processed by the precompiler to expand all macros. */

SECTIONS {
  ROM_BASE = 0x80000000; /* ... but actually position independent */

  . = 0x0;
  .l1_seq (NOLOAD): { *(.l1_seq) }
  l1__seq_alloc_base = ALIGN(0x10);

  . = (NUM_CORES * 0x400); /* NUM_CORES * 1KiB */
  .l1_prio (NOLOAD): { *(.l1_prio) }
  .l1 (NOLOAD): { *(.l1) }
  l1_alloc_base = ALIGN(0x10);

  eoc_reg = 0x40000000;
  wake_up_reg = 0x40000004;
  tcdm_start_address_reg = 0x40000008;
  tcdm_end_address_reg = 0x4000000C;
  nr_cores_address_reg = 0x40000010;

  fake_uart = 0xC0000000;
}
