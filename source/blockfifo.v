// Block FIFO Verilog Module

// Author: Matthew Knight
// Date: 2017-03-21

// The Block FIFO has an output signal to signal when full. When full the module
// does not accept writes to memory, but allows for reads. The FIFO only becomes
// empty when it is reset.

module blockfifo #(
    parameter len = 8,
    parameter wid = 8
)
(
    input clk, reset, write, 
    output reg ready,

    input [(wid-1):0] data_i,
    input [(addrWid-1):0] readPtr,
    output reg [(wid-1):0] data_o
);

    parameter addrWid = $clog2(len);
    reg [(addrWid-1):0] writePtr;

    reg [(wid-1):0] ram [0:(len-1)];

    // Combinational
    always @(*) begin
	
	// Determine if buffer is full
	if (writePtr == len)
	    ready = 'b0;
	else
	    ready = 1'b1;
	
	if (readPtr < len)
	    data_o = ram[readPtr];
	else
	    data_o = 'b0;

    end

    // Sequential logic
    always @(posedge clk or posedge reset) begin
	if (reset)
	    writePtr <= 'b0;
	else begin
	    if (write & ready) begin
		ram[writePtr] <= data_i;
		writePtr <= writePtr + 1'b1;
	    end
	end
    end

endmodule
