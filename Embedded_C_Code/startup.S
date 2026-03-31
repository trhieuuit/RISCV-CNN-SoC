# File: startup.S
.section .init
.global _start

_start:
    # 1. Khởi tạo con trỏ Stack (sp - thanh ghi x2)
    # Stack ở 0x1000 (DMEM là 16KB (0x4000)) 
    # Stack sẽ tự động mọc ngược từ trên xuống dưới trong DMEM.
    li sp, 0x10000 

    # 2. Gọi main
    call main

    # Kích hoạt cờ DONE!
    # Ghi giá trị 1 vào địa chỉ 0x2000 (DMEM)
    li t0, 0x2000      
    li t1, 1
    sw t1, 0(t0)       

    # 4. CPU dừng hoạt động bằng ecall
    ecall

die:
    j die