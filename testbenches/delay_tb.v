// Delay Verilog Test Bench 

// Author: Matthew Knight
// Date: 2017-02-27

`include "../source/delay.v"

module delay_tb();

    reg clk = 'b0;
    reg reset = 'b0;
    reg [7:0] data;
    wire [7:0] out, inter;
    
    integer i;

    delay d_0(.clk(clk), .reset(reset), .D(data), .Q(inter));
    delay d_1(.clk(clk), .reset(reset), .D(inter), .Q(out));

    initial begin
	$dumpfile("delay.vcd");
	$dumpvars(0, clk, reset, data, inter, out);

	for (i=0; i < 10; i=i+1) begin
	    data <= i;  
	    #1 clk = 1'b1;
	    #1 clk = 'b0;
	end
    end

endmodule
