// State Control Module

// Author: Matthew Knight
// Date: 2017-02-22

// This module keeps track of which state the composite synthesizer is in from
// timers.

module stateControl(
    input clk, reset,
    output reg [2:0] state
);

    parameter Hsync = 3'd0;
    parameter porch = 3'd1;
    parameter colourBurst = 3'd2;
    parameter activeVideo = 3'd3;
    
    reg [11:0] count;

    always @(*) begin
	if (count < 75)
	    state = porch;
	else if (count < 310)
	    state = Hsync;
	else if (count < 340)
	    state = porch;
	else if (count < 465)
	    state = colourBurst;
	else if (count < 545)
	    state = porch;
	else
	    state = activeVideo;
    end

    always @(posedge clk) begin
	if (reset)
	    count <= 1'b0;
	else if (count >= 12'd3175)
	    count <= 1'b0;
	else
	    count <= count + 1'b1;
    end

endmodule
