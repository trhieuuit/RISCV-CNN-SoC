
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -T link.ld startup.S main.c -o program.elf -nostdlib

if ($?) {
       riscv-none-elf-objcopy -O binary program.elf program.bin

    py make_mem.py
    
    Write-Host "--- THANH CONG! Da co file machine_code.mem ---" -ForegroundColor Green
} else {
    Write-Host "--- LOI BIEN DICH! Vui long kiem tra lai code ---" -ForegroundColor Red
}

