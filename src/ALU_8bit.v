`timescale 1ns/1ps
module ALU_8bit (
    input [7:0] A,
    input [7:0] B,
    input [3:0] Immediate,
    input UseImmediate,
    input [3:0] ALUOp,
    output reg [7:0] Result,
    output reg CarryOut,
    output reg Zero,
    output reg Overflow,   // Overflow flag
    output reg Underflow   // Underflow flag
);
    wire [7:0] ALU_B = UseImmediate ? {4'b0000, Immediate} : B;
    reg [8:0] Extended;
    
    always @(*) begin
        CarryOut = 0;
        Overflow = 0;
        Underflow = 0;
        case (ALUOp)
            4'b0000: begin // ADD / ADDI
                Extended = A + ALU_B;
                Result = Extended[7:0];
                CarryOut = Extended[8];
                Overflow = Extended[8]; // For unsigned addition, overflow is the carry-out.
            end
            4'b0001: begin // SUB / SUBI
                if (A < ALU_B) begin
                    Underflow = 1;
                    Result = A - ALU_B; // Wraps in two's complement
                end else begin
                    Underflow = 0;
                    Result = A - ALU_B;
                end
                CarryOut = 0;
                Overflow = 0;
            end
            4'b0010: Result = A & ALU_B;
            4'b0011: Result = A | ALU_B;
            4'b0100: Result = A ^ ALU_B;
            4'b0101: Result = ~A;
            4'b0110: Result = A << ALU_B[1:0];
            4'b0111: Result = A >> ALU_B[1:0];
            default: Result = 8'b0;
        endcase
        Zero = (Result == 8'b0);
    end
endmodule
