
module sdram_controller(
		input logic Read_valid, Write_ready, Reset,
		input logic [15:0] Datawrite,
		input logic [11:0] Address,
		output logic busy,
		output logic [15:0] DataRead
		);

		
	parameter Bank = 0;
	reg clk = CLOCK_50;

	
	
	
sdram_controller sdram_controlleri (
    /* HOST INTERFACE */
    .wr_addr(Address), 
    .wr_data(Datawrite),
    .rd_data(DataRead),
    .busy(busy), .rd_enable(rd_enable), .wr_enable(wr_enable), .rst_n(rst_n), .clk(clk),

    /* SDRAM SIDE */
    .addr(addr), .bank_addr(bank_addr), .data(data), .clock_enable(clock_enable), .cs_n(cs_n), .ras_n(ras_n), .cas_n(cas_n), .we_n(we_n), .data_mask_low(data_mask_low), .data_mask_high(data_mask_high)
);

endmodule