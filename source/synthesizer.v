// Composite Video Synthesizer Verilog Implementation

// Author: Matthew Knight
// Date: 2017-02-24

`include "../source/lut.v"
`include "../source/delay.v"

module synthesizer(
    input clk, reset,
    input [5:0] colourNum,
    input [7:0] phase,
    output [7:0] video
);
    
    wire [7:0] offset, offset1, phase, phase1, phaOff;
    wire signed [7:0] sine, amp, amp1;
    wire signed [15:0] ireg;
    wire [7:0] ireg2;

    // Look-up Tables/ROM
    lut #(64, 8, "../source/data/phase.data") colourPhase(
	.clk(clk), 
	.reset(reset), 
	.addr(colourNum), 
	.data(phaOff)
    );
    
    lut #(64, 8, "../source/data/amplitude.data") colourAmplitude(
	.clk(clk), 
	.reset(reset), 
	.addr(colourNum), 
	.data(amp)
    );
    
    lut #(64, 8, "../source/data/offset.data") colourOffset(
	.clk(clk), 
	.reset(reset), 
	.addr(colourNum), 
	.data(offset)
    );
    
    lut #(256, 8, "../source/data/sine.data") lutSine(
	.clk(clk), 
	.reset(reset), 
	.addr(phase1 + phaOff), 
	.data(sine)
    );

    // Time delays (simple D Flip-flops)
    delay d_0(
	.clk(clk), 
	.reset(reset), 
	.D(phase), 
	.Q(phase1)
    );
    
    delay d_1(
	.clk(clk), 
	.reset(reset), 
	.D(offset), 
	.Q(offset1)
    );
    
    delay d_2(
	.clk(clk), 
	.reset(reset), 
	.D(amp), 
	.Q(amp1)
    );

    // Put the components together 
    assign ireg2 = ireg >> 7;
    assign ireg = amp1*sine;
    assign video = ireg2 + offset1;

endmodule
