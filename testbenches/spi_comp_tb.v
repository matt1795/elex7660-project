// Numerically Controlled Oscillator Verilog Test Bench

// Author: Matthew Knight
// Date: 2017-02-21

module nco_tb();
    
    reg clk;
    reg reset = 0;
    reg [7:0] active = 8'd200;
    reg [15:0] fcw = 16'd4692;
    wire [7:0] phase, out, colourb;
    wire [2:0] state;
    
    nco testGuy(.reset(reset), .clk(clk), .fcw(fcw), .out(phase));
    lutsine testguy2(.clk(clk), .phase(phase), .amp(colourb));
    stateControl testGuy3(.clk(clk), .reset(reset), .state(state));
    dacmux testGuy4(.state(state), .colourb(colourb), .active(active),
    .toDAC(out));

    // Generate clock
    always 
	#10 clk = ~clk;

    initial begin
	$dumpfile("spi_comp.vcd");
	$dumpvars(0, clk, reset, fcw, phase, out, state);
	clk = 0;
	#1 reset = 1;
	#20 reset = 0;
	
	#20000 $finish;
    end
    
endmodule
