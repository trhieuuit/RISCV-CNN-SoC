# File: startup.S
.section .init
.global _start

_start:
    # 1. Initialize Stack Pointer (sp - register x2)
    # The stack is set to 0x10000 ((DMEM is 16KB (0x4000)).
    li sp, 0x10000 

    # 2. Call the C main function
    call main

    # 3. Signal completion (DONE flag) - Write value 1 to address 0x2000 in DMEM
    li t0, 0x2000      
    li t1, 1
    sw t1, 0(t0)       

    # 4. Halt CPU execution using ecall
    ecall

die:
    j die