`timescale 1ns / 1ps

module ALU_8bit_tb;

    // Testbench signals
    reg [7:0] A, B;
    reg [1:0] ALUOp;
    wire [7:0] Result;
    wire CarryOut;
    
    
    // Instantiate the ALU
    ALU_8bit uut (
        .A(A),
        .B(B),
        .ALUOp(ALUOp),
        .Result(Result),
        .CarryOut(CarryOut)
    );
    
    initial begin
        // Test ADD
        A = 8'b00000101; B = 8'b00000011; ALUOp = 2'b00; #10;
        $display("ADD: A=%b, B=%b, Result=%b, CarryOut=%b", A, B, Result, CarryOut);

        // Test SUB
        A = 8'b00001000; B = 8'b00000100; ALUOp = 2'b01; #10;
        $display("SUB: A=%b, B=%b, Result=%b, CarryOut=%b", A, B, Result, CarryOut);

        // Test AND
        A = 8'b10101010; B = 8'b11001100; ALUOp = 2'b10; #10;
        $display("AND: A=%b, B=%b, Result=%b", A, B, Result);

        // Test OR
        A = 8'b10101010; B = 8'b11001100; ALUOp = 2'b11; #10;
        $display("OR: A=%b, B=%b, Result=%b", A, B, Result);

        $stop;
    end
    
endmodule
