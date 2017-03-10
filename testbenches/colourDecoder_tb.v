// Colour Decoder Verilog Test Bench

// Author: Matthew Knight
// Date: 2017-03-07

`include "../source/colourDecoder.v"

module colourDecoder_tb();
    
    reg clk, reset;
    reg [5:0] colourNum;
    wire [7:0] video;
    
    integer i;
    
    // Module instantiation
    colourDecoder c_0(.clk(clk), .reset(reset), .colourNum(colourNum),
	.video(video));

    initial begin
	$dumpfile("colourDecoder.vcd");
	$dumpvars(0, colourDecoder_tb);
	clk = 1'b0;
	reset = 1'b0;
	#1 reset = 1'b1;
	#2 reset = 'b0;

	for (i = 0; i < 64; i = i+1)
	    #28 colourNum = i;
	    
	#28 $finish;
    end

    always 
	#1 clk = ~clk;

endmodule
