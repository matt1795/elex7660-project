// This Module Takes input SPI Signal and stores the data on temporary buffer
// Called Buffer. It will then send the data to the RAM.
// By William Harkness and Mathew Knight

`include PTR_write_max 319
module SPI ( 	input logic [8:0] Data,
				input logic sclk, i_SPI_valid, i_RAM_ready,
				output logic o_SPI_ready, o_RAM_valid, Mode,
				output logic [7:0] Data_RAM); 
				
	logic [8:0] Buffer [319];				// Temporary Buffer
	logic PTR_Read = 0, PTR_write = 0, Overflow = 0;		// Pointers to the Temporary Buffer
	
	
	always @(posedge sclk) begin					// On Positive Clock Edge
	
		if(i_SPI_valid && o_SPI_ready) begin 		// If input data is valid 
			assign Buffer[PTR_write] <= data;		// And Buffer is ready
													// Move Data to Buffer
													 
			if (PTR_write == PTR_write_max)			// This increments the
				assign PTR_write <= '0;				// Write pointer
			else
				assign PTR_write <= PTR_write + '1;
													
			if (PTR_write == PTR_Read)				// If Buffer is Full
				assign Overflow <= '1;				// Indicate Buffer is Full
			else 
				assign Overflow <= '0;				
		end
	end
				
	always begin
		if (PTR_write == PTR_Read)
			if (Overflow)
				assign o_SPI_ready <= '0;
			else
				assign o_SPI_ready <= '1;
		else 
			assign o_SPI_ready <= '1;
	end
endmodule				
