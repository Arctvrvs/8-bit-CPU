# 8-bit CPU Instruction Set

## Supported Instructions
| Mnemonic | Opcode | Description |
|----------|--------|-------------|
| ADDI Rn, imm | 1000 | Add immediate value to register |
| SUBI Rn, imm | 1001 | Subtract immediate value from register |
| BEQZ Rn, offset | 1010 | Branch if zero |
| BNEZ Rn, offset | 1011 | Branch if not zero |
| JMP addr | 1100 | Jump to address |
| LD Rn, addr | 1101 | Load from memory |
| ST Rn, addr | 1110 | Store to memory |
| NOP | 1111 | No operation |

## Encoding Format
Each instruction is **8-bits** wide:
- First 4 bits = **Opcode**
- Next 2 bits = **Destination Register**
- Last 2-4 bits = **Immediate value, memory address, or offset**
