// Colour Decoder Verilog Module

// Author: Matthew Knight
// Date: 2017-02-27

// This module takes a colour code adhering to the NES colour palette (64
// colours), a clk, and asynchronous reset, and outputs video data to be sent to
// the DAC for the colour burst or active video.

`include "../source/nco.v"
`include "../source/synthesizer.v"

module colourDecoder(
    input clk, reset,
    input [5:0] colourNum,
    output [7:0] video
);

    wire [7:0] phase;

    // Frequency control word for a 3579545 Hz output and a 50Mhz clock
    reg [23:0] fcw = 24'd1201096;

    // Instantiation of NCO
    nco #(24) osc(
	.clk(clk), 
	.reset(reset),
	.fcw(fcw), .out(phase)
    );

    // Instantiation of colour synthesizer
    synthesizer s_0(
	.clk(clk), 
	.reset(reset), 
	.colourNum(colourNum),
	.phase(phase), 
	.video(video)
    );

endmodule
