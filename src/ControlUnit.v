`timescale 1ns/1ps
module ControlUnit (
    input clk,
    input [7:0] Instruction,
    output reg [3:0] ALUOp,
    output reg WriteEnable,
    output reg [1:0] WriteReg,
    output reg [1:0] ReadRegA,
    output reg [1:0] ReadRegB,
    output reg [3:0] Immediate,
    output reg UseImmediate,
    output reg [1:0] MemOp,
    output reg [3:0] BranchOffset
);
    wire [3:0] opcode = Instruction[7:4];
    wire [1:0] Rd = Instruction[3:2];
    wire [1:0] operand = Instruction[1:0];
    
    // Define legal opcodes.
    // HALT is now defined as 0001.
    wire legal = (opcode == 4'b0001) ||  // HALT
                 (opcode == 4'b1000) ||
                 (opcode == 4'b1001) ||
                 (opcode == 4'b1010) ||
                 (opcode == 4'b1011) ||
                 (opcode == 4'b1100) ||
                 (opcode == 4'b1101) ||
                 (opcode == 4'b1110) ||
                 (opcode == 4'b1111) ||
                 (opcode == 4'b0101) ||
                 (opcode == 4'b0011);
    
    always @(*) begin
        // Default values
        ALUOp = opcode;
        WriteEnable = 1;
        UseImmediate = 0;
        MemOp = 2'b00;
        Immediate = {2'b00, operand};
        WriteReg = Rd;
        ReadRegA = Rd;
        ReadRegB = operand;
        BranchOffset = 4'b0000;
        
        // If HALT is detected (opcode 0001) then disable operations.
        if (opcode == 4'b0001) begin
            WriteEnable = 0;
            ALUOp = 4'b0000;
            UseImmediate = 0;
            MemOp = 2'b00;
            Immediate = 4'b0000;
            BranchOffset = 4'b0000;
        end 
        else if (!legal) begin
            $display("Illegal Instruction detected: %b", Instruction);
            WriteEnable = 0;
            ALUOp = 4'b0000;
            UseImmediate = 0;
            MemOp = 2'b00;
            Immediate = 4'b0;
            BranchOffset = 4'b0;
            ReadRegB = 2'b00;
        end 
        else begin
            // Immediate arithmetic:
            if (opcode == 4'b1000) begin // ADDI
                ALUOp = 4'b0000;
                UseImmediate = 1;
                Immediate = {2'b00, operand};
            end else if (opcode == 4'b1001) begin // SUBI
                ALUOp = 4'b0001;
                UseImmediate = 1;
                Immediate = {2'b00, operand};
            end else begin
                ALUOp = opcode;
                UseImmediate = 0;
            end
            
            // LD and ST handling:
            if (opcode == 4'b1101) begin
                MemOp = 2'b01;
                Immediate = {2'b00, operand};
            end else if (opcode == 4'b1110) begin
                MemOp = 2'b10;
                WriteEnable = 0;
                Immediate = {2'b00, operand};
            end else begin
                MemOp = 2'b00;
            end
            
            // Branching:
            if (opcode == 4'b1010 || opcode == 4'b1011) begin
                WriteEnable = 0;
                BranchOffset = {{2{operand[1]}}, operand};
            end else begin
                BranchOffset = 4'b0;
            end
            
            // For non-immediate/non-memory, use operand as second register.
            if (!(opcode == 4'b1000 || opcode == 4'b1001 || opcode == 4'b1101 || opcode == 4'b1110))
                ReadRegB = operand;
            else
                ReadRegB = 2'b00;
        end
        
        $display("Time=%0d | Instr=%b | ALUOp=%b | WE=%b | WR=%b | RR_A=%b | RR_B=%b | Imm=%b | UseImm=%b | BranchOffset=%b",
                 $time, Instruction, ALUOp, WriteEnable, WriteReg, ReadRegA, ReadRegB, Immediate, UseImmediate, BranchOffset);
    end
endmodule
