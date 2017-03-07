// Composite Video Synthesizer Verilog Test Bench

// Author: Matthew Knight
// Date: 2017-03-07

`include "../source/synthesizer.v"

module synthesizer_tb();
    
    reg clk, reset;
    reg [5:0] colourNum;
    reg [7:0] phase = 0;
    wire [7:0] video;
    
    integer i;
    
    // Module instantiation
    synthesizer s_0(.clk(clk), .reset(reset), .colourNum(colourNum),
	.phase(phase), .video(video));

    initial begin
	$dumpfile("synthesizer.vcd");
	$dumpvars(0, clk, reset, colourNum, phase, video, synthesizer_tb.s_0);
	clk = 1'b0;
	reset = 1'b0;
	#1 reset = 1'b1;
	#2 reset = 'b0;

	for (i = 0; i < 64; i = i+1)
	    #10 colourNum = i;
	
	$finish;
    end

    always 
	#1 clk = ~clk;

endmodule
