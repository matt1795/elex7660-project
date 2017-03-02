// Look-up Table Verilog Test Bench

// Author: Matthew Knight
// Date: 2017-02-25

`include "../source/lut.v"

module lut_tb();

    reg clk, reset;
    reg [$clog2(64)-1:0] colourNum;
    wire [7:0] offset;
    
    integer i;

    lut #(64, 8, "../source/data/offset.data") 
	lutSine(.clk(clk), .reset(reset), .addr(colourNum), .data(offset));

    reg [7:0] testVector [0:63];
    reg [7:0] errorCount = 0;

    initial begin
	
	// Load up test Vector
	$readmemb("../source/data/offset.data", testVector);
	$dumpfile("lut.vcd");
	$dumpvars(0, clk, reset, colourNum, offset);
	clk = 'b0;
	reset = 'b0;
	#1 reset = 1'b1;
	#1 reset = 'b0;
	
	// Loop through the entire ROM
	for (i=0; i < 64; i=i+1) begin
	    colourNum = i;
	    #1 clk = 1'b1;
	    #1 clk = 'b0;
	
	
	    $display("Address: %h, Data: %d, Expected: %d", colourNum, offset,
	    testVector[i]);
	
	    if (offset !== testVector[i]) begin
		$display("Error for address %b", colourNum);
		errorCount = errorCount+1;
	    end
	end

	$display("Testing Complete...");
	$display("Errors: %d", errorCount);
	$finish;
    end

endmodule
