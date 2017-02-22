// Sine Function Look-Up Table

// Author: Matthew Knight
// Date: 2017-02-22

module lutsine (
    input clk,
    input [7:0] phase,
    output [7:0] amp
);
    reg amp;
    reg [7:0] sine [0:255];
    
    always @(posedge clk) 
	amp <= sine[phase];

    initial begin
	$readmemb("../source/sine.data", sine);
    end

endmodule
