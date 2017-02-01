// Sine Generator Verilog Test Bench

// Author: Matthew Knight
// Date: 2017-02-01

module sineGen_tb();
    reg clk = 0; 
    reg reset = 0;
    reg signed [7:0] in = 0;		// Input to resonator
    wire signed [7:0] out;		// output of resonator

    sineGen res(.clk(clk), .reset(reset), .in(in), .out(out));

    // Clock
    always begin
	#1 clk = ~clk;
    end

    // Dump output
    initial begin
	$dumpfile("sineGen.vcd");
	$dumpvars(0, clk, in, out);
    end

    // Generating an input
    initial begin
	#1  in = 1;
	#2 in = 0;
	#50000 $finish;
    end

endmodule
