// Copyright (C) 1991-2016 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus Prime License Agreement,
// the Altera MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Altera and sold by Altera or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

module compositeDriver
(
	// System Clock
	input CLOCK_50,
	
	// DAC Interface
	output [7:0] dac,							// DAC Data
	output dacClk, dacClk_n,					// DAC Diff Clock
	input [8:0] sdata,
	input sclk


);
	
	
	
	
	reg reset = 1'b0;
	wire write;
	wire [7:0] data_i;
	wire [7:0] line;
	wire ready;
	reg [8:0] i;
	reg [8:0] pixel;
	
	// Differential Clock signal to DAC
	assign dacClk = ~CLOCK_50;
	assign dacClk_n = ~dacClk;

	
	// Video Signal Generator Module
	videoGen v_0(
		.clk(CLOCK_50),
		.reset(reset),
		.write(write),
		.data_i(data_i),
		.line(line),
		.ready(ready),
		.dac(dac)
	);

	// SPI Controller
	SPI spi_0(
		.CLK(CLOCK_50),
		.reset(reset),
		.Next_Line(ready),
		.clk_SPI(sclk),
		.Row_Select(line),
		.Data(sdata),
		.Data_O(data_i),
		.Data_Valid(write)
	);
	
endmodule

