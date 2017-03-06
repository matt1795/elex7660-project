// This Module Takes input SPI Signal and stores the data on temporary buffer
// Called Buffer. It will then send the data to the RAM.
// By William Harkness and Mathew Knight



module SPI ( 	input logic [8:0] Data,
				input logic clk_SPI, i_SPI_valid, i_RAM_ready,
				output logic o_SPI_ready, o_RAM_valid, Mode, clk_RAM,
				output logic [7:0] Data_RAM); 
				
	logic [8:0] Buffer [7:0];							
									// Mini Buffer for 
	reg PTR_Read, PTR_Write, Overflow;	
									// Pointers to the Temporary Buffer
	
	initial begin
		PTR_Read <= '0;
		PTR_Write <= '0;
		Overflow <= '0;
	end
	
	
	parameter PTR_Write_max = 319;
	parameter PTR_Read_max = 319;
	
	always @(posedge clk_SPI) begin	// On Positive Clock Edge
			
		if(i_SPI_valid && o_SPI_ready) begin 		// If input data is valid 
			Buffer[PTR_Write] <= Data;				// And Buffer is ready
													// Move Data to Buffer						
		 
			if (PTR_Write == PTR_Write_max)			// This increments the
				assign PTR_Write = '0;				// Write pointer
			else
				assign PTR_Write = PTR_Write + '1;
				
			if ((PTR_Write + 1'b1 == PTR_Read) || ((PTR_Write == 8'hFF) && (PTR_Read == 8'h00)))
													// If Buffer is Full
				assign Overflow = '1;				// Indicate Buffer is Full
			else 
				assign Overflow = '0;								
							
		end
	end
	
	
	
					
	always @(*)  begin
	
	assign Mode = Buffer[PTR_Read][8];
	assign Data_RAM = Buffer[PTR_Read][7:0];
	
		if (PTR_Write == PTR_Read) begin
		
			if (Overflow) begin					// If Full Buffer 
				assign o_SPI_ready = '0;		// Buffer can't be written to
				assign o_RAM_valid = '1;		// Output from Buffer is valid
			end
			
			else begin
				assign o_SPI_ready = '1;		// Buffer can be written to
				assign o_RAM_valid = '0;		// Output isn't valid
			end
		end
		
		else  begin
			assign o_SPI_ready = '1;			// Buffer Can be written to
			assign o_RAM_valid = '1;			// And read from
		end
	end
	
	always @(posedge CLOCK_50) begin			// On Positive Clock Edge
	
		if(i_RAM_ready && o_RAM_valid) begin 		// If input data is valid 

			if (PTR_Read == PTR_Read_max)			// This increments the
				assign PTR_Read = '0;				// Read pointer
			else
				assign PTR_Read = PTR_Read + '1;
		end
	end
		
endmodule				
