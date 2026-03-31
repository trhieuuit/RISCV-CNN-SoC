/* File: link.ld */
OUTPUT_ARCH("riscv")
ENTRY(_start)

MEMORY
{
  /* IMEM 16KB bắt đầu từ 0x0 */
  imem (rx)  : ORIGIN = 0x00000000, LENGTH = 64K
}

SECTIONS
{
  .text : {
    *(.init)    /* Ép code khởi động của file .S phải nằm ở dòng đầu tiên */
    *(.text*)   /* Code C nằm ở đây */
    *(.rodata*) /* Các hằng số (nếu có) */
  } > imem
  
  /* Bỏ qua các section rác của GCC để file .bin không bị phình to */
  /DISCARD/ : {
    *(.eh_frame)
    *(.comment)
  }
}