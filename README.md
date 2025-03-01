<<<<<<< HEAD
=======
# 8-bit CPU in Verilog (Vivado)

## Overview
This project is a custom **8-bit CPU** designed and simulated in **Vivado**.  
It features:
- **Custom Instruction Set** (ADDI, SUBI, BEQZ, etc.)
- **Python Assembler** to convert assembly to machine code
- **Testbenches** for ALU, Registers, Memory, and CPU
- **Successful Simulation in Vivado**

## Project Structure
- **src/** → Verilog source files  
- **sim/** → Testbenches  
- **assembler/** → Python-based assembler  
- **docs/** → Architecture diagrams, instruction set  

## Getting Started

### 1. Clone the Repository
```sh
git clone https://github.com/yourusername/8-bit-CPU.git
cd 8-bit-CPU
```

### 2. Run the Assembler
```sh
python assembler/assembler.py assembler/example.asm assembler/example.bin assembler/example.hex
```

### 3. Simulate in Vivado
1. Open **Vivado Design Suite**
2. Load the project  
3. Set **CPU_tb.v** as the top module  
4. Run **simulation**  



## License
This project is licensed under the **MIT License**.
>>>>>>> 24cf5f6 (Initial commit: Added CPU design, assembler, and testbenches)

