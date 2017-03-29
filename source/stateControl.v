// State Control Module

// Author: Matthew Knight
// Date: 2017-02-22

// This module keeps track of which state the composite synthesizer is in from
// timers.

`include "../source/colourDecoder.v"

// State defines
`define VBLANK 0
`define HLINE 1
`define VIDEO 2

module stateControl(
    input clk, reset, write,
    input [7:0] data_i,
    output ready
    output reg [7:0] dac
);

    parameter Hsync = 8'd0;
    parameter blank = 8'd57;
    
    wire [7:0] video;
    reg colourReset;
    reg [5:0] colourNum;
    reg [9:0] pixel, line;
    reg [11:0] count;
     
    // Colour Decoder Module
    colourDecoder c_0(
	.clk(clk), 
	.reset(reset | colourReset),
	.colourNum(colourNum), 
	.video(video)
    );

    // Line buffer
    blockfifo #(320, 8) lineBuffer(
	.clk(clk),
	.reset(reset),
	.write(write),
	.ready(ready),
	.data_i(data_i),
	.data_o(colourNum)
	.readPtr(pixel)
    );

    // State variables
    reg [2:0] state;
    reg [7:0] line;
    reg [8:0] pixel;

    always @(*) begin
	
	// The timings for a single line
	if (count < 75) begin
	    dac = blank;
	    colourReset = 'b1;
	    pixel = 'b0;
	end
	else if (count < 12'd310)
	    dac = Hsync;
	else if (count < 12'd337)
	    dac = blank;
	else if (count < 12'd340) begin
	    colourNum = 6'h3F;
	    colourReset = 1'b0;
	end
	else if (count < 12'd465) begin
	    dac = video;
	    colourReset = 'b0;
	end
	else if (count < 12'd545)
	    dac = blank;
	else
	    dac = 8'hFF;
    end

    always @(posedge clk or posedge reset) begin
	if (reset) begin
	    count <= 1'b0;
	    colourReset <= 'b0;
	    state <= VSYNC;
	    line <= 'b0;
	    pixel <= 'b0;
	end
	else if (count >= 12'd3175)
	    count <= 'b0;
	else
	    count <= count + 1'b1;
    end

endmodule
