# RISC-V RV32I 5-Stage Pipeline Core on FPGA (KV260)

## 📌 Overview

This project implements a **fully functional 32-bit RISC-V (RV32I) processor** using a **5-stage pipeline architecture** and deploys it on the **Xilinx KV260 FPGA platform**. The design is written in Verilog.

The processor is capable of executing compiled RISC-V machine code and has been validated through simulation (using [riscv-test](https://github.com/riscv-software-src/riscv-tests)) and real FPGA deployment.


---

## 🚀 Features

* RV32I base instruction set support
* 5-stage pipeline:

  * Instruction Fetch (IF)
  * Instruction Decode (ID)
  * Execute (EX)
  * Memory (MEM)
  * Write Back (WB)
* Hazard handling:

  * Data forwarding and Pipeline stalling (for Load instructions)
  * Control hazard flushing
* FPGA-tested with KV260

---

## 🧠 Architecture


---

## 🧩 Supported Instructions (RV32I)

Includes:

* R-type: ADD, SUB, AND, OR, XOR, SLT
* I-type: ADDI, LW, ANDI, ORI
* S-type: SW
* B-type: BEQ, BNE
* U-type: LUI
* J-type: JAL
* System: ECALL (set Done flag)


---

## 🧪 Simulation

### ⚙️ Setup
- Set `tb_riscv.v` as the **top module**
- Load RISC-V instructions into **instruction memory (IMEM)** using one of the methods below

---

###  Method 1: Load instructions in `tb_riscv.v`

```verilog
module tb_riscv.v (
...
  uut.instruction_memory.rom_r[0] = 32'h00500093;  // addi x1, x0, 5 
  uut.instruction_memory.rom_r[1] = 32'h00a00113;  // addi x2, x0, 10
  uut.instruction_memory.rom_r[2] = 32'h002081b3;  // add  x3, x1, x2
...

```
---
###  Method 2: Load instructions using `imem.v`
- In `imem.v`
```verilog
module imem#((
...
  // !!! Comment this line if yorue loading machine code in test bench module !!! 
  // !!! Remember to paste the machine code in machine_code.mem !!!
  //$readmemh("D:/Hoc_Tap/Dai_hoc/HK6/DoAn1/Pipeline_RISCV/Pipeline_RISCV.srcs/sources_1/imports/new/machine_code.mem",  rom_r);
...
```
- Then paste the instructions in `machine_code.mem`

---

## ⚙️ FPGA Integration (KV260)

### 🔌 Bitstream Generation & Programming
- Check block design in `design1.bd`
- Set top module as `design_1_wrapper.v`
- Generate bitstream
- Load `design1_wrapper.bit` from `Pipeline_RISCV\Pipeline_RISCV.runs\impl_1\` into KV260 FPGA

### 💻 Embedded 


## 📊 Performance

* Achieved frequency:  100 MHz
* Critical path slack: 2.481 ns

---

## 📚 Future Improvements

* Integrate with an accelerator (Systolic array or CGRA)
  

