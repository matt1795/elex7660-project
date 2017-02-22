// Numerically Controlled Oscillator Verilog Test Bench

// Author: Matthew Knight
// Date: 2017-02-21

module nco_tb();
    
    reg clk;
    reg [15:0] fcw;
    wire [7:0] out;

    always @(*)
	#1 clk = ~clk;

    always @(posedge clk) begin

    
endmodule
