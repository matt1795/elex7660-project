// Video Signal Generator Module

// Author: Matthew Knight
// File: videoGen.v
// Date: 2017-04-05

module videoGen(
	input clk, reset, write,
	input [7:0] data_i,
	output ready,
	output [7:0] line,
	output [7:0] dac
);

	// wires to connect modules
	wire [8:0] pixel;
	wire [7:0] lum;
	wire phaseReset;
	reg bufReset;


	always @(negedge clk) begin
		if (pixel == 9'd330)
			bufReset <= 1'b1;
		else
			bufReset <= 1'b0;
	end

	// Timer Module for controlling sequences in the signal
	timer t_0(
		.clk(clk),
		.reset(reset),
		.phaseReset(phaseReset),
		.pixel(pixel),
		.video(lum),
		.dac(dac),
		.line(line)
	);
	 
	// Line Buffer to store the next raster line in
	blockfifo lineBuffer(
		.clk(clk),
		.reset(reset | bufReset),
		.write(write), 
		.ready(ready),
		.data_i(data_i),
		.readPtr(pixel),
		.data_o(lum)
	);
		

	
endmodule