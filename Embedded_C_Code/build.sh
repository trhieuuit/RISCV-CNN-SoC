#!/bin/bash

rm -f *.o *.elf *.bin

riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -O1 -ffreestanding -nostdlib -c startup.S -o startup.o
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -O1 -ffreestanding -nostdlib -c main.c -o main.o

riscv64-unknown-elf-ld -m elf32lriscv -T link.ld startup.o main.o -o firmware.elf

riscv64-unknown-elf-objcopy -O binary -j .text firmware.elf firmware.bin

ls -lh firmware.bin
echo "Done"