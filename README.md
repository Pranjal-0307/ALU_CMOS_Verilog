# 🔧 8-Bit CMOS-Based Pipelined ALU
## 🧠 CMOS Logic Implementation

This project implements an 8-bit Arithmetic Logic Unit (ALU) using custom CMOS logic gates and Verilog HDL, structured with a 4-stage pipelined architecture and a dual-phase clock system.

It is designed for hardware enthusiasts and VLSI learners, providing hands-on experience in digital logic design and transistor-level circuit implementation.

The ALU supports fundamental arithmetic and logical operations while maintaining modularity, pipeline efficiency, and carry/borrow flag tracking.
## ⚙️ Features
| 🔢 Feature        | 📝 Description                                                        |
| ----------------- | --------------------------------------------------------------------- |
| 8 Operations      | ADD, SUB, AND, OR, XOR, NOT A, NOT B, INC A                           |
| ⏱️ Pipeline       | 4-stage pipelined architecture for overlapped execution               |
| 🔄 Clocking       | Dual-phase clocks (clk1, clk2) for safe timing and no race conditions |
| 🧠 CMOS Logic     | Built entirely with NAND, NOR, NOT, XOR gates                         |
| 🗃️ Register Bank | 16 × 8-bit registers                                                  |
| 💾 Memory         | 256 × 8-bit memory cells                                              |
| 🚩 Flags          | Carry/Borrow tracking for arithmetic operations                       |
| 🧩 Modular        | Clean Verilog gate-level design for easy expansion                    |

## 🏗️ Architecture Overview

The 4-stage pipeline operates as follows:
| 🔢 Stage                 | 🛠️ Function                                     |
| ------------------------ | ------------------------------------------------ |
| 1️⃣ Fetch Stage          | Load operands A and B from the register bank     |
| 2️⃣ Execute Stage        | Perform the selected ALU operation               |
| 3️⃣ Register Write Stage | Write the result to the destination register     |
| 4️⃣ Memory Write Stage   | Store result in memory if write-enable is active |

## 🛠️ Tools Used
| 🧰 Tool        | 📝 Purpose                                 |
| -------------- | ------------------------------------------ |
| Verilog HDL    | Design and modeling of digital hardware    |
| Icarus Verilog | Compilation and simulation of Verilog code |
| GTKWave        | Waveform visualization and signal analysis |

## 📤 Output Signals
| 🟢 Signal    | 📝 Description                                            |
| ------------ | --------------------------------------------------------- |
| Zout         | 8-bit result of ALU operation                             |
| Carry/Borrow | 1-bit flag indicating carry-out (ADD/INC) or borrow (SUB) |

## 📂 File Descriptions
| 📄 File Name | 📝 Description                                                        |
| ------------ | --------------------------------------------------------------------- |
| ALU.v        | Main Verilog file containing ALU logic, pipeline stages, and datapath |
| ALU_tb.v     | Testbench simulating ALU operations with dual clocks                  |
| ALU.vcd      | Value Change Dump (VCD) file for waveform analysis in GTKWave         |
| result       | Text output file capturing Zout and Carry/Borrow from simulation      |
| README.md    | Project overview, architecture, tool usage, and file documentation    |

## ⚡ Simulation and Verification
```
1.Compile the Verilog code using Icarus Verilog
iverilog -o ALU_tb ALU.v ALU_tb.v
2.Run the simulation
vvp ALU_tb
3.View waveforms in GTKWave
4.Check the result file for Zout and Carry/Borrow outputs
```
## 📝 Key Notes

### ⚡ Pipeline ensures high throughput, but requires dual-phase clocks for proper timing.

### 🧠 CMOS gate-level design provides a strong foundation for transistor-level digital design.

### 🧩 Modular structure allows future expansion of operations, register bank, and memory.





