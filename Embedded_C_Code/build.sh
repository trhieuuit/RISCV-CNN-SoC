#!/bin/bash

# Dọn dẹp file cũ
rm -f *.o *.elf *.bin

echo "[1] Bien dich startup.S va main.c..."
# Dùng cờ -O1 để tối ưu code. -ffreestanding để không dùng thư viện OS.
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -O1 -ffreestanding -nostdlib -c startup.S -o startup.o
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -O1 -ffreestanding -nostdlib -c main.c -o main.o

echo "[2] Chay Linker script."
# THÊM CỜ -m elf32lriscv VÀO ĐÂY ĐỂ TRÁNH LỖI XUNG ĐỘT 32/64 BIT
riscv64-unknown-elf-ld -m elf32lriscv -T link.ld startup.o main.o -o firmware.elf

echo "[3] Tach lay phan loi Ma may..."
# Chi lay section .text de tao file .bin
riscv64-unknown-elf-objcopy -O binary -j .text firmware.elf firmware.bin

# Kiem tra ket qua
ls -lh firmware.bin
echo "File firmware.bin da san sang!"