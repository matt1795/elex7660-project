// This Module Takes input SPI Signal and stores the data on temporary buffer
// Called Buffer. It will then send the data to the RAM.
// By William Harkness and Mathew Knight

`include PTR_Write_max 16'd319
`include PTR_Read_max 16'd319

module SPI ( 	input logic [8:0] Data,
				input logic clk_SPI, i_SPI_valid, i_RAM_ready,
				output logic o_SPI_ready, o_RAM_valid, Mode, clk_RAM,
				output logic [7:0] Data_RAM); 
				
	logic [8:0] Buffer [319];							
									// Mini Buffer for 
	logic PTR_Read = 0, PTR_Write = 0, Overflow = 0;	
									// Pointers to the Temporary Buffer
	
	
	always @(posedge clk_SPI) begin	// On Positive Clock Edge
	
		if(i_SPI_valid && o_SPI_ready) begin 		// If input data is valid 
			assign Buffer[PTR_Write] <= data;		// And Buffer is ready
													// Move Data to Buffer
													 
			if (PTR_write == PTR_write_max)			// This increments the
				assign PTR_Write <= '0;				// Write pointer
			else
				assign PTR_Write <= PTR_Write + '1;
				
			if ((PTR_write + 1'b1 == PTR_Read) || ((PTR_write == 8'hFF) && (PTR_Read == 8'h00)))
													// If Buffer is Full
				assign Overflow <= '1;				// Indicate Buffer is Full
			else 
				assign Overflow <= '0;								
							
		end
	end
				
	always begin
	
		if (PTR_write == PTR_Read)begin
		
			if (Overflow) begin					// If Full Buffer 
				assign o_SPI_ready <= '0;		// Buffer can't be written to
				assign o_RAM_valid <= '1;		// Output from Buffer is valid
			end
			
			else begin
				assign o_SPI_ready <= '1;		// Buffer can be written to
				assign o_RAM_valid <= '0;		// Output isn't valid
			end
		end
		
		else  begin
			assign o_SPI_ready <= '1;			// Buffer Can be written to
			assign o_RAM_valid <= '1;			// And read from
		end
	
		assign  Data_RAM <= Buffer[PTR_Read][7:0];	
												// Output data
		assign 	Mode <= Buffer[PTR_Read][8];
						`						/// Output data type
	end
	
	
	always @(posedge clk_RAM) begin	// On Positive Clock Edge
	
		if(i_RAM_ready && o_RAM_valid) begin 		// If input data is valid 

			if (PTR_Read == PTR_Read_max)			// This increments the
				assign PTR_Read <= '0;				// Read pointer
			else
				assign PTR_Read <= PTR_Read + '1;
	end
	
	
	always
		#0.5us clk_RAM = ~clk_RAM ;				// Generated clock for RAM Communication
		
		
endmodule				
