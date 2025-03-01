`timescale 1ns/1ps

module ControlUnit_tb;

    // Testbench variables
    reg clk;
    reg [7:0] Instruction;
    wire [1:0] ALUOp, WriteReg, ReadRegA, ReadRegB;
    wire WriteEnable;

    // Instantiate the Control Unit
    ControlUnit uut (
        .clk(clk),
        .Instruction(Instruction),
        .ALUOp(ALUOp),
        .WriteEnable(WriteEnable),
        .WriteReg(WriteReg),
        .ReadRegA(ReadRegA),
        .ReadRegB(ReadRegB)
    );

    // Generate clock signal
    always #5 clk = ~clk;

    initial begin
        // Initialize variables
        clk = 0;

        // Test ADD instruction (Opcode = 0001, Rd = 01, Rs = 10)
        Instruction = 8'b00010110; // ADD R1, R2
        #10;
        $display("ADD: ALUOp=%b, WriteEnable=%b, WriteReg=%b, ReadRegA=%b, ReadRegB=%b",
                 ALUOp, WriteEnable, WriteReg, ReadRegA, ReadRegB);

        // Test SUB instruction (Opcode = 0010, Rd = 10, Rs = 11)
        Instruction = 8'b00101011; // SUB R2, R3
        #10;
        $display("SUB: ALUOp=%b, WriteEnable=%b, WriteReg=%b, ReadRegA=%b, ReadRegB=%b",
                 ALUOp, WriteEnable, WriteReg, ReadRegA, ReadRegB);

        $stop;
    end

endmodule
