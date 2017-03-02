// Composite Video Synthesizer Verilog Implementation

// Author: Matthew Knight
// Date: 2017-02-24

`include "lut.v"
`include "delay.v"

module synthesizer(
    input clk, reset,
    input [7:0] colourNum,
    input [7:0] phase,
    output reg [7:0] video
);
    
    wire [7:0] offset, phaOff, amp;

    // Look-up Tables/ROM
    lut #(64, 8, "../source/data/phase.data")
	colourPhase(.clk(clk), .addr(colourNum), .data(phaOff));
    
    lut #(64, 8, "../source/data/amplitude.data")
	colourAmplitude(.clk(clk), .addr(colourNum), .data(amp));
    
    lut #(64, 8, "../source/data/offset.data")
	colourOffset(.clk(clk), .addr(colourNum), .data(offset));
    
    lut #(256, 8, "../source/data/sine.data")
	lutSine(.clk(clk), .addr(phase1 + phaOff), .data(sine));

    // Time delays (simple D Flip-flops)
    delay d_0(.clk(clk), .D(phase), .Q(phase1));
    delay d_1(.clk(clk), .D(offset), .Q(offset1));
    delay d_2(.clk(clk), .D(amp), .Q(amp1));

    always
	video = ((amp*sine) >> 8) + dc1;

endmodule
