// Numerically Controlled Oscillator Verilog Test Bench

// Author: Matthew Knight
// Date: 2017-02-21

module nco_tb();
    
    reg clk;
    reg reset = 0;
    reg [15:0] fcw = 16'd4692;
    wire [7:0] phase, out;
    
    nco testGuy(.reset(reset), .clk(clk), .fcw(fcw), .out(phase));
    lutsine testguy2(.clk(clk), .phase(phase), .amp(out));

    // Generate clock
    always 
	#10 clk = ~clk;

    initial begin
	$dumpfile("nco.vcd");
	$dumpvars(0, clk, reset, fcw, phase, out);
	clk = 0;
	#1 reset = 1;
	#20 reset = 0;
	
	#2000 $finish;
    end
    
endmodule
