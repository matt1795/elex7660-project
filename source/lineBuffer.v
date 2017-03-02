// Line Buffer Verilog Implementation

// Author: Matthew Knight
// Date: 2017-02-24

// This module will be used to store an entire line of composite video. For
// testing purposes it will be used as ROM for line test data. Each value is an
// encoded colour which is later converted to the required modulation values.

module lineBuffer (
    input [8:0] pixelPtr,
    output [7:0] colourNum
);
    reg [7:0] line [0:319];
    
    assign amp = line[pixelPtr];

    initial begin
	$readmemb("../source/bufTest.data", line);
    end

endmodule
