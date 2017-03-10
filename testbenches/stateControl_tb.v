// State Control Test Bench

// Author: Matthew Knight
// Date: 2017-03-09

// This module keeps track of which state the composite synthesizer is in from
// timers.

`timescale 10ns/1ns
`include "../source/stateControl.v"

module stateControl_tb();
    
    reg clk, reset;
    wire [7:0] dac;
    
    // Module instantiation
    stateControl s_0(.clk(clk), .reset(reset), .dac(dac));
    
    initial begin
	$dumpfile("stateControl.vcd");
	$dumpvars(0, s_0);
	clk = 'b0;
	reset = 'b0;
	#1 reset = 1'b1;
	#1 reset = 'b0;
	#10000 $finish;
    end

    always
	#1 clk = ~clk;
endmodule
