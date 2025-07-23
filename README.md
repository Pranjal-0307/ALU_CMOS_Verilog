# 🔧 8-Bit CMOS-Based Pipelined ALU in Verilog

This project implements an 8-bit Arithmetic Logic Unit (ALU) using custom CMOS logic gates and Verilog HDL, structured with a 4-stage pipelined architecture and a dual-phase clock system. Designed as a deep dive into both digital logic and transistor-level circuit design, this ALU handles fundamental arithmetic and logical operations — perfect for VLSI learners and hardware enthusiasts.

---

## ⚙️ Features

- 🔢 Executes 8 operations: ADD, SUB, AND, OR, XOR, NOT A, NOT B, INC A  
- ⏱️ 4-stage pipelined architecture for overlapped execution  
- 🔄 Dual-phase clocking (`clk1`, `clk2`) for precise timing  
- 🧠 Built entirely with CMOS logic: NAND, NOR, NOT, XOR  
- 🗃️ Register Bank: 16 × 8-bit registers  
- 💾 Memory Unit: 256 × 8-bit memory cells  
- 🧩 Modular Verilog structure with clean gate-level design  
- 🚩 Supports carry and borrow flag tracking

---

## 🏗️ Architecture Overview

The ALU operates on a 4-stage pipeline:

1. 🧮 **Fetch Stage** – Load operands A and B from the register bank  
2. 🔧 **Execute Stage** – Perform the selected ALU function  
3. 📥 **Register Write Stage** – Write result to destination register  
4. 🧾 **Memory Write Stage** – Store result in memory if enabled

Clocks `clk1` and `clk2` alternate to drive adjacent pipeline stages safely and without race conditions.

---

## 🛠️ Tools Used

| 🧰 Tool             | 📝 Purpose     
|-------------------- |---------------|
| Verilog HDL         | Design and modeling of digital hardware   |
| Icarus Verilog      | Compilation and simulation of Verilog code |
| GTKWave             | Waveform viewing and signal analysis      |

---

## 📤 Output Signals

- 🟢 `Zout`: 8-bit result of the ALU operation  
- 🔁 `Carry/Borrow`: 1-bit flag indicating carry-out (ADD/INC) or borrow (SUB)
- ## 📄 File Descriptions

| File Name     | Description                                                                 |
|---------------|-----------------------------------------------------------------------------|
| `ALU.v`       | Main Verilog file containing the ALU logic, pipeline stages, control, and data path. |
| `ALU_tb.v`    | Testbench for simulating the ALU with various test cases using dual clocks. |
| `ALU.vcd`     | Value Change Dump (VCD) file generated from simulation, used to view waveforms in GTKWave. |
| `result`      | Text output file capturing the Zout and Carry/Borrow values from simulation for each operation. |
| `README.md`   | Project overview, architecture, tool usage, and file documentation (you are reading it). |
