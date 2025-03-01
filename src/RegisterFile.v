`timescale 1ns/1ps
module RegisterFile (
    input clk,
    input reset,
    input WriteEnable,
    input [1:0] WriteReg,
    input [7:0] WriteData,
    input [1:0] ReadRegA,
    input [1:0] ReadRegB,
    output reg [7:0] ReadDataA,
    output reg [7:0] ReadDataB,
    output [7:0] R0, R1, R2, R3
);
    reg [7:0] registers [0:3];
    integer i;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            registers[0] <= 8'b00000000; // R0 starts at 0
            registers[1] <= 8'h02;
            registers[2] <= 8'h03;
            registers[3] <= 8'h04;
        end else if (WriteEnable) begin
            registers[WriteReg] <= WriteData;
        end
    end

    always @(*) begin
        ReadDataA = registers[ReadRegA];
        ReadDataB = registers[ReadRegB];
    end

    assign R0 = registers[0];
    assign R1 = registers[1];
    assign R2 = registers[2];
    assign R3 = registers[3];
endmodule
