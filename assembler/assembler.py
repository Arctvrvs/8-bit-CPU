#!/usr/bin/env python3
import sys

# Define opcodes (all as 4-bit strings)
OPCODES = {
    "HALT": "0001",   # HALT opcode: 0001 (followed by 0000)
    "ADDI": "1000",
    "SUBI": "1001",
    "BEQZ": "1010",
    "BNEZ": "1011",
    "JMP":  "1100",
    "LD":   "1101",
    "ST":   "1110",
    "NOP":  "1111",
    # Add additional opcodes here if needed.
}

# Define register mapping (2-bit strings)
REGISTERS = {
    "R0": "00",
    "R1": "01",
    "R2": "10",
    "R3": "11",
}

def assemble_instruction(line):
    """
    Convert an assembly instruction line into an 8-bit binary string.
    Lines may include comments (after a '#' character) which are ignored.
    """
    # Remove comments and extra whitespace.
    line = line.split("#")[0].strip()
    if not line:
        return None  # Skip empty lines

    # Split the line into parts (using whitespace or commas as delimiters)
    parts = line.replace(",", " ").split()
    instr = parts[0].upper()  # Instruction mnemonic

    if instr not in OPCODES:
        raise ValueError(f"Invalid instruction: {instr}")

    opcode = OPCODES[instr]

    # HALT instruction: no operands.
    if instr == "HALT":
        if len(parts) != 1:
            raise ValueError(f"Syntax error for HALT: {line}")
        return opcode + "0000"  # 0001 0000

    # For instructions with an immediate field (ADDI, SUBI)
    if instr in ["ADDI", "SUBI"]:
        if len(parts) != 3:
            raise ValueError(f"Syntax error: {line}")
        rd = REGISTERS.get(parts[1].upper())
        if rd is None:
            raise ValueError(f"Invalid register: {parts[1]}")
        try:
            imm = int(parts[2])
        except ValueError:
            raise ValueError(f"Immediate must be an integer: {line}")
        # Assume a 2-bit immediate (range: -2 to 3, using two's complement)
        if imm < -2 or imm > 3:
            raise ValueError(f"Immediate out of range (-2 to 3): {line}")
        imm_bin = format(imm & 0b11, "02b")
        return opcode + rd + imm_bin

    # For branch instructions (BEQZ, BNEZ)
    elif instr in ["BEQZ", "BNEZ"]:
        if len(parts) != 3:
            raise ValueError(f"Syntax error: {line}")
        rd = REGISTERS.get(parts[1].upper())
        if rd is None:
            raise ValueError(f"Invalid register: {parts[1]}")
        try:
            offset = int(parts[2])
        except ValueError:
            raise ValueError(f"Offset must be an integer: {line}")
        if offset < -2 or offset > 3:
            raise ValueError(f"Branch offset out of range (-2 to 3): {line}")
        offset_bin = format(offset & 0b11, "02b")
        return opcode + rd + offset_bin

    # For JMP (Jump)
    elif instr == "JMP":
        if len(parts) != 2:
            raise ValueError(f"Syntax error: {line}")
        try:
            addr = int(parts[1])
        except ValueError:
            raise ValueError(f"Jump address must be an integer: {line}")
        if addr < 0 or addr > 15:
            raise ValueError(f"Jump address out of range (0-15): {line}")
        addr_bin = format(addr, "04b")  # 4-bit jump address
        return opcode + addr_bin

    # For LD and ST instructions
    elif instr in ["LD", "ST"]:
        if len(parts) != 3:
            raise ValueError(f"Syntax error: {line}")
        rd = REGISTERS.get(parts[1].upper())
        if rd is None:
            raise ValueError(f"Invalid register: {parts[1]}")
        try:
            mem_addr = int(parts[2])
        except ValueError:
            raise ValueError(f"Memory address must be an integer: {line}")
        if mem_addr < 0 or mem_addr > 3:
            raise ValueError(f"Memory address out of range (0-3): {line}")
        mem_addr_bin = format(mem_addr, "02b")
        return opcode + rd + mem_addr_bin

    # For NOP instruction
    elif instr == "NOP":
        return opcode + "0000"

    else:
        raise ValueError(f"Unknown instruction: {line}")

def assemble_file(input_file, output_bin, output_hex):
    """
    Reads the assembly file, assembles each instruction,
    and writes the output to a text file (binary) and a hex file.
    """
    binary_lines = []
    hex_lines = []
    
    with open(input_file, "r") as f:
        for line in f:
            try:
                bin_str = assemble_instruction(line)
                if bin_str:
                    binary_lines.append(bin_str)
                    hex_lines.append(format(int(bin_str, 2), "02X"))
            except ValueError as err:
                print(f"Error: {err}")
    
    # Write binary file as text (one binary string per line)
    with open(output_bin, "w") as f:
        for bin_str in binary_lines:
            f.write(bin_str + "\n")
    
    # Write hex file (for use with $readmemh)
    with open(output_hex, "w") as f:
        for hex_line in hex_lines:
            f.write(hex_line + "\n")
    
    print("Assembly successful!")
    print(f"Binary output: {output_bin}")
    print(f"Hex output: {output_hex}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python assembler.py <input.asm> <output.bin> <output.hex>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_bin = sys.argv[2]
    output_hex = sys.argv[3]
    assemble_file(input_file, output_bin, output_hex)
