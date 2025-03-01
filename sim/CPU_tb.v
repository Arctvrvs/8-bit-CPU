`timescale 1ns/1ps

module CPU_tb;

    reg clk;
    reg reset;
    wire [7:0] ALUResult;
    wire [7:0] R0, R1, R2, R3;
    wire CarryOut;
    wire [3:0] PC;
    wire [7:0] Instruction;

    // Instantiate the CPU
    CPU dut (
        .clk(clk),
        .reset(reset),
        .ALUResult(ALUResult),
        .R0(R0),
        .R1(R1),
        .R2(R2),
        .R3(R3),
        .CarryOut(CarryOut),
        .PC(PC),
        .Instruction(Instruction)
    );

    // Generate Clock Signal
    always #5 clk = ~clk;  // 10ns period (5ns high, 5ns low)

    // Test Sequence
    initial begin
        // Initialize clock and reset
        clk = 0;
        reset = 1;
        #10;  // Hold reset high for 10ns
        reset = 0;

        // Monitor the CPU state every cycle
        $monitor("Time=%0t | PC=%b | Instr=%b | R0=%h | R1=%h | R2=%h | R3=%h | ALU=%h | Carry=%b", 
                  $time, PC, Instruction, R0, R1, R2, R3, ALUResult, CarryOut);

        // Run simulation for a fixed number of cycles
        #200; 

        // Stop Simulation
        $stop;
    end

endmodule
