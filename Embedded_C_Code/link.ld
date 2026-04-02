/* File: link.ld */
OUTPUT_ARCH("riscv")
ENTRY(_start)

MEMORY
{
  /* IMEM 16KB starting at 0x0 */
  imem (rx)  : ORIGIN = 0x00000000, LENGTH = 64K
}

SECTIONS
{
  .text : {
    *(.init)    
    *(.text*)   
    *(.rodata*) 
  } > imem
  
  /DISCARD/ : {
    *(.eh_frame)
    *(.comment)
  }
}