// Sine Wave Generator Verilog Implementation

// Author: Matthew Knight
// Date: 2017-02-01

module sineGen (
    input clk,				// Expected 50MHz clk
    input reset,			// Reset clears all registers
    input signed [7:0] in,			// Main inpu signal
    output signed [7:0] out		// Output signal, hopefully a sine wave
);
    
    integer i;

    // System parameters:
    parameter b0 = 56;
    parameter a2 = -1;
    reg out;
    reg signed [7:0] y [0:2];
    

    initial begin
	for (i = 0; i < 3; i = i+1)
	    y[i] = 0;
    end

    always @(posedge clk) begin
	y[2] = y[1];
	y[1] = y[0];
	y[0] = in*b0 + (10*y[1])/8 + a2*y[2];
	out = y[0];
    end

endmodule
    
