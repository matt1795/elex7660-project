// Look-up Table Verilog Module

// Author: Matthew Knight
// Date: 2017-02-25

// This is a parameterized model for creating Look-up Tables.

module lut #(
    parameter L = 256,			// Length of the table
    parameter W = 8,			// Width of each element
    parameter file = ""			// File to source rom data
)
(
    input clk, reset,			// Clock input
    input [(addrWid-1):0] addr,		// Address for element selection    
    output reg [(W-1):0] data		// Table output data
);

    // Address width
    parameter addrWid = $clog2(L);
    
    // Instantiation of ROM
    reg [(W-1):0] rom [0:(L-1)];

    // Data for lookup table
    initial
	$readmemb(file, rom);

    // data is updated on the positive edge
    always @(posedge clk or posedge reset) begin
	if (reset)
	    data = 'b0;
	else begin
	    if (addr < L)
		data <= rom[addr];
	    else
		data <= 'b0;
	end
    end

endmodule
