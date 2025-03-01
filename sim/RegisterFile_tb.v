`timescale 1ns/1ps

module RegisterFile_tb;

    // Testbench variables
    reg clk;
    reg [7:0] WriteData;
    reg [1:0] WriteReg, ReadRegA, ReadRegB;
    reg WriteEnable;
    wire [7:0] ReadDataA, ReadDataB;

    // Instantiate the Register File
    RegisterFile uut (
        .clk(clk),
        .WriteData(WriteData),
        .WriteReg(WriteReg),
        .WriteEnable(WriteEnable),
        .ReadRegA(ReadRegA),
        .ReadRegB(ReadRegB),
        .ReadDataA(ReadDataA),
        .ReadDataB(ReadDataB)
    );

    // Generate clock signal
    always #5 clk = ~clk;

    initial begin
        // Initialize variables
        clk = 0; WriteEnable = 0; WriteData = 0; WriteReg = 0;
        ReadRegA = 0; ReadRegB = 0;

        // Test 1: Write and read from R0
        #10 WriteEnable = 1; WriteReg = 2'b00; WriteData = 8'b10101010; // Write to R0
        #10 WriteEnable = 0; ReadRegA = 2'b00; // Read from R0
        #10 $display("R0 = %b", ReadDataA);

        // Test 2: Write and read from R1
        #10 WriteEnable = 1; WriteReg = 2'b01; WriteData = 8'b01010101; // Write to R1
        #10 WriteEnable = 0; ReadRegB = 2'b01; // Read from R1
        #10 $display("R1 = %b", ReadDataB);

        // Test 3: Simultaneous read from R0 and R1
        #10 ReadRegA = 2'b00; ReadRegB = 2'b01;
        #10 $display("R0 = %b, R1 = %b", ReadDataA, ReadDataB);

        $stop;
    end

endmodule
