`timescale 1ns/1ps
module InstructionMemory (
    input [3:0] addr,         // 4-bit address (16 instructions)
    output reg [7:0] instr    // 8-bit instruction output
);
    reg [7:0] memory [0:15];
    integer i;
    
    initial begin
        // Pre-fill memory with NOPs (1111 0000)
        for (i = 0; i < 16; i = i + 1)
            memory[i] = 8'b11110000;
        // Then load compiled instructions from hex file
        $readmemh("All_Test.hex", memory);
    end
    
    always @(*) begin
        instr = memory[addr];
    end
endmodule
