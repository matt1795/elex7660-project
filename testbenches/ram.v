// DE0 Nano Ram Emulator verilog implementation

// Author: Matthew Knight
// Date: 2017-02-17

// This verilog module is meant to emulate the IS42S16160B synchronous DRAM
// found on the DE0 Nano evaluation board for simulation purposes.

module is42s16160b (
    input clk,				// System clock
    input cke,				// Clock enable
    input cs_n,				// Chip select
    input ras_n,			// Row Address Strobe Command
    input cas_n,			// Column Address Strobe Command
    input we_n,				// Write enable
    input ba1,				// Bank select 1
    input ba0,				// Bank select 0
    input dqmh,				// Upper byte in/out mask
    input dqml,				// Lower byte in/out mask
    inout [15:0] data			// Bidirectional data, 16 bit
);

endmodule
