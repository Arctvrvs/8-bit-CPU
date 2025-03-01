`timescale 1ns/1ps
module Memory (
    input clk,
    input we,
    input [1:0] addr,
    input [7:0] data_in,
    output [7:0] data_out
);
    reg [7:0] mem [0:3];
    integer i;
    
    initial begin
        for (i = 0; i < 4; i = i + 1)
            mem[i] = 8'b0;
    end
    
    always @(posedge clk) begin
        if (we)
            mem[addr] <= data_in;
    end
    
    assign data_out = mem[addr];
endmodule
