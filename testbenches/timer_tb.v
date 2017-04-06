// Timer Module for Composite video

// Author: Matthew Knight
// File: timer.v
// Date: 2017-04-04

// This module is to control the timing of the syncing pulses in the composite
// video standard.

// Timescale to make 50Mhz clock/
`timescale 10ns/1ns

// Defines
`define CW 16
`define SYNC 8'h0
`define BLANK 8'h7F
`define VIDEO 8'hFF
`define VERT 1'b0
`define HORZ 1'b1

module timer_tb ();
    
    reg clk, reset, state;		// Clock Signal
    reg [(`CW-1):0] clockCount;		// counter variable
    reg [(`CW+7):0] vertical [0:57];
    reg [(`CW+7):0] horizontal [0:5];
    reg [6:0] stateCount;		// Counter for moving up states
    reg [7:0] dac;
    reg [(`CW+7):0] next;
    reg [9:0] line;
    
    // Actual Module
    
    always @(*) begin
	if (state) begin
	    next = horizontal[stateCount+1'b1];
	    dac = horizontal[stateCount];
	end else begin
	    next = vertical[stateCount+1'b1];
	    dac = vertical[stateCount];
	end
    end

    always @(posedge clk or posedge reset) begin
	if (reset) begin
	    clockCount <= 'b0;
	    stateCount <= 'b0;
	    state <= 'b0;
	end else begin
	    if (state) begin
		// Horizontal
		if (clockCount >= 'hC6B) begin
		    clockCount <= 'b0;
		    stateCount <= 'b0;
		    line <= line + 1'b1;
		    if (line >= 'd242)
			state <= 1'b0;
		end else

		// Increment counter
		clockCount <= clockCount + 1'b1;	
	    
	    end else begin
		// end of vertical
		if (clockCount >= 'hF86F) begin
		    clockCount <= 'b0;
		    stateCount <= 'b0;
		    state <=1'b1;
		    line <= 1'b0;
		end else

		// Increment counter
		clockCount <= clockCount + 1'b1;	
	    end

	    if (clockCount >= next[(`CW+7):8]) begin
		stateCount <= stateCount + 1'b1;
	    end
	end
    end
    
    initial begin
	state = 'b0;
	// Pre-Equalizing Pulses
	vertical[0] = 'h0000 + `SYNC;
	vertical[1] = 'h7200 + `BLANK;
	vertical[2] = 'h63500 + `SYNC;
	vertical[3] = 'h6A800 + `BLANK;
    
	vertical[4] = 'hC6C00 + `SYNC;
	vertical[5] = 'hCDE00 + `BLANK;
	vertical[6] = 'h12A100 + `SYNC;
	vertical[7] = 'h131400 + `BLANK;
     
	vertical[8] = 'h18D800 + `SYNC;
	vertical[9] = 'h194A00 + `BLANK;
	vertical[10] = 'h1F0D00 + `SYNC;
	vertical[11] = 'h1F8000 + `BLANK;

	// Vertical Sync Pulses
	vertical[12] = 'h254400 + `SYNC;
	vertical[13] = 'h2A8F00 + `BLANK;
	vertical[14] = 'h2B7900 + `SYNC;
	vertical[15] = 'h30C400 + `BLANK;
    
	vertical[16] = 'h31B000 + `SYNC;
	vertical[17] = 'h36FB00 + `BLANK;
	vertical[18] = 'h37E500 + `SYNC;
	vertical[19] = 'h3D3000 + `BLANK;
     
	vertical[20] = 'h3E1C00 + `SYNC;
	vertical[21] = 'h436700 + `BLANK;
	vertical[22] = 'h445100 + `SYNC;
	vertical[23] = 'h499C00 + `BLANK;

	// Posy-Equalizing Pulses
	vertical[24] = 'h4A8800 + `SYNC;
	vertical[25] = 'h4AFA00 + `BLANK;
	vertical[26] = 'h50BD00 + `SYNC;
	vertical[27] = 'h512F00 + `BLANK;
    
	vertical[28] = 'h56F400 + `SYNC;
	vertical[29] = 'h576600 + `BLANK;
	vertical[30] = 'h5D2900 + `SYNC;
	vertical[31] = 'h5D9B00 + `BLANK;
     
	vertical[32] = 'h636000 + `SYNC;
	vertical[33] = 'h63D200 + `BLANK;
	vertical[34] = 'h699500 + `SYNC;
	vertical[35] = 'h6A0700 + `BLANK;

	// Blank lines
	vertical[36] = 'h6FCC00 + `SYNC;
	vertical[37] = 'h70B700 + `BLANK;
	vertical[38] = 'h7C3800 + `SYNC;
	vertical[39] = 'h7D2300 + `BLANK;
	vertical[40] = 'h88A400 + `SYNC;
	vertical[41] = 'h898F00 + `BLANK;
	vertical[42] = 'h951000 + `SYNC;
	vertical[43] = 'h95FB00 + `BLANK;
	vertical[44] = 'hA17C00 + `SYNC;
	vertical[45] = 'hA26700 + `BLANK;
	vertical[46] = 'hADE800 + `SYNC;
	vertical[47] = 'hAED300 + `BLANK;
	vertical[48] = 'hBA5400 + `SYNC;
	vertical[49] = 'hBB3F00 + `BLANK;
	vertical[50] = 'hC6C000 + `SYNC;
	vertical[51] = 'hC7AB00 + `BLANK;
	vertical[52] = 'hD32C00 + `SYNC;
	vertical[53] = 'hD41700 + `BLANK;
	vertical[54] = 'hDF9800 + `SYNC;
	vertical[55] = 'hE08300 + `BLANK;
	vertical[56] = 'hEC0400 + `SYNC;
	vertical[57] = 'hECEF00 + `BLANK;
    
	horizontal[0] = 'h0000 + `SYNC;
	horizontal[1] = 'hEA00 + `BLANK;
	horizontal[2] = 'h10800 + `BLANK;
	horizontal[3] = 'h18500 + `BLANK;
	horizontal[4] = 'h1D500 + `VIDEO;
	horizontal[5] = 'hC1B00 + `BLANK;
    end
    
    // 50MHz clock
    always
	#1 clk = ~clk;

    initial begin
	$dumpfile("timer_tb.vcd");
	$dumpvars(0, clk, clockCount, next, dac, stateCount, line, state);
	clk = 'b0;
	reset = 'b0;
	clockCount = 'b0;
	stateCount = 'b0;
	#4000000 $finish;
    end

endmodule 
