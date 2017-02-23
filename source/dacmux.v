// DAC Multiplexer Module

// Author: Matthew Knight
// Date: 2017-02-22

// This module chooses what signal will drive the DAC. This is simply based on
// the current state.

module dacmux (
    input [2:0] state,
    input [7:0] colourb, active,
    output reg [7:0] toDAC
); 

    always @(*)
	case(state)
	    0: toDAC = 8'd0;
	    1: toDAC = 8'd57;
	    2: toDAC = colourb;
	    3: toDAC = active;
	    default: toDAC = 8'b0;
	endcase

endmodule
