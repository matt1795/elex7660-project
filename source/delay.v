// Delay Verilog Module

// Author: Matthew Knight
// Date: 2017-02-26

// This module is simply a D Flip-flop for the purpose of delaying a signal for
// a single clock cycle.

module delay #(
    parameter W = 8			// Width of the bus
)
(
    input clk, reset,			// Clock input
    input [(W-1):0] D,			// Data input
    output reg [(W-1):0] Q		// Delayed output
);

    always @(posedge clk or posedge reset)
	if (reset)
	    Q <= 'b0;
	else
	    Q <= D;

endmodule
