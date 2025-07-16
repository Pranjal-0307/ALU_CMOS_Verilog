# 8-Bit CMOS-Based Pipelined ALU in Verilog

This project implements an **8-bit pipelined Arithmetic Logic Unit (ALU)** using **CMOS logic gates** and **Verilog HDL**, designed to perform fundamental arithmetic and logical operations with a 4-stage pipeline architecture. It is intended for digital design learners and VLSI enthusiasts who want to understand transistor-level CMOS implementations in practical HDL projects.

---

## 🚀 Features

- **8-bit ALU** capable of executing 8 operations:
  - ADD, SUB, AND, OR, XOR, NOT A, NOT B, INC A
- **4-stage pipelined architecture** using two-phase clocking (`clk1`, `clk2`)
- **CMOS logic-level design** using NAND, NOR, and NOT gates
- Includes:
  - **Register bank (16×8)**
  - **Memory unit (256×8)**
- Designed in **Verilog HDL** and simulated using **Icarus Verilog** + **GTKWave**

---

## 🛠️ Tools Used

| Tool           | Purpose                                |
|----------------|----------------------------------------|
| **Verilog HDL**| Hardware description and logic design  |
| **Icarus Verilog** | Simulation and testing               |
| **GTKWave**    | Waveform analysis and timing inspection |
