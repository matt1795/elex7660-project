// Numerically Controlled Oscillator Verilog Module

// Author: Matthew Knight
// Date: 2017-02-21

// N is the width of the frequency control word and 
// M is the width of the truncated output

module nco
#(parameter N = 16, M = 8)
(   
    input clk, reset, 
    input [(N-1):0] fcw,
    output [(M-1):0] out
);
    
    // count registers
    reg [(N-1):0] count, count_next;
    
    assign out = count[N:(N-M)];

    always @(*)
	count_next = count + fcw;
	
    always @(posedge clk or posedge reset)
	if ( reset) begin
	    count <= 1'b0;
	end else begin
	    count <= count_next;
	end

endmodule
