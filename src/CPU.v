`timescale 1ns/1ps
module CPU (
    input clk,
    input reset,
    output [7:0] ALUResult,   // Final result (ALU result or memory load)
    output [7:0] R0, R1, R2, R3,
    output CarryOut,
    output [3:0] PC,        // Exported PC for debugging
    output [7:0] Instruction  // Exported latched instruction (IR)
);
    // Global HALT flag
    reg halt;
    
    // Instruction Fetch
    reg [3:0] pc_reg;
    assign PC = pc_reg;
    
    wire [7:0] instr_mem_out;
    InstructionMemory imem (
        .addr(pc_reg),
        .instr(instr_mem_out)
    );
    
    // Latch instruction in IR
    reg [7:0] IR;
    always @(posedge clk or posedge reset) begin
        if (reset)
            IR <= 8'b0;
        else
            IR <= instr_mem_out;
    end
    assign Instruction = IR;
    
    // Internal Data & Control
    wire [7:0] ReadDataA, ReadDataB;
    wire [3:0] Immediate;
    wire UseImmediate;
    wire [3:0] ALUOp;
    wire WriteEnable;
    wire [1:0] WriteReg, ReadRegA, ReadRegB;
    wire [7:0] ALUResultWire;
    wire CarryOutWire;
    wire [1:0] MemOp;
    wire [7:0] MemData;
    wire [3:0] BranchOffset;
    
    // Override WriteEnable if halted.
    wire effective_WriteEnable = (halt) ? 1'b0 : WriteEnable;
    
    RegisterFile regFile (
        .clk(clk),
        .reset(reset),
        .WriteEnable(effective_WriteEnable),
        .WriteReg(WriteReg),
        .WriteData((MemOp == 2'b01) ? MemData : ALUResultWire),
        .ReadRegA(ReadRegA),
        .ReadRegB(ReadRegB),
        .ReadDataA(ReadDataA),
        .ReadDataB(ReadDataB),
        .R0(R0), .R1(R1), .R2(R2), .R3(R3)
    );
    
    ALU_8bit alu (
        .A(ReadDataA),
        .B(ReadDataB),
        .Immediate(Immediate),
        .UseImmediate(UseImmediate),
        .ALUOp(ALUOp),
        .Result(ALUResultWire),
        .CarryOut(CarryOutWire),
        .Zero(),        // Not used at top-level
        .Overflow(),    // Can be monitored
        .Underflow()    // Can be monitored
    );
    
    ControlUnit control (
        .clk(clk),
        .Instruction(IR),
        .ALUOp(ALUOp),
        .WriteEnable(WriteEnable),
        .WriteReg(WriteReg),
        .ReadRegA(ReadRegA),
        .ReadRegB(ReadRegB),
        .Immediate(Immediate),
        .UseImmediate(UseImmediate),
        .MemOp(MemOp),
        .BranchOffset(BranchOffset)
    );
    
    Memory memory_inst (
        .clk(clk),
        .we((MemOp == 2'b10)),
        .addr(Immediate[1:0]),
        .data_in(ReadDataA),
        .data_out(MemData)
    );
    
    assign ALUResult = (MemOp == 2'b01) ? MemData : ALUResultWire;
    assign CarryOut = CarryOutWire;
    
    // PC Update Logic with HALT support:
    // Extract the opcode from IR.
    wire [3:0] opcode = IR[7:4];
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_reg <= 0;
            halt <= 0;
        end else begin
            // If not already halted, check for HALT.
            if (!halt) begin
                if (opcode == 4'b0001) begin
                    // Set halt flag on HALT instruction
                    halt <= 1;
                    pc_reg <= pc_reg; // hold PC
                end else begin
                    case (opcode)
                        4'b1010: begin // BEQZ
                            if (ReadDataA == 8'b0)
                                pc_reg <= pc_reg + $signed(BranchOffset);
                            else
                                pc_reg <= pc_reg + 1;
                        end
                        4'b1011: begin // BNEZ
                            if (ReadDataA != 8'b0)
                                pc_reg <= pc_reg + $signed(BranchOffset);
                            else
                                pc_reg <= pc_reg + 1;
                        end
                        4'b1100: begin // JMP
                            pc_reg <= Immediate;
                        end
                        default: begin
                            pc_reg <= pc_reg + 1;
                        end
                    endcase
                end
            end
            else begin
                // Once halted, keep PC constant.
                pc_reg <= pc_reg;
            end
        end
    end

endmodule
