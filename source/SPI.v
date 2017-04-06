// This Module Takes 8 bit input from SPI Signal and stores the data on temporary buffer
// Called Buffer. It will then send 16 bit data to the RAM.
// By William Harkness



module SPI ( 	input wire [8:0] Data,
				input wire clk_SPI, i_SPI_valid, i_RAM_ready, CLK,
				output reg o_SPI_ready, o_RAM_valid, Mode,
				output reg [15:0] Data_RAM); 
				
	parameter PTR_max = 159;
	
	reg [16:0] Buffer [PTR_max:0];		// 320 pixal = one line
							
	reg [8:0] BitConvert;		// For coverting the 8 bit input
	reg Count;						// To 16 bit buffer
			
	//wire CLK;						// Should be CLK 50 MHz

	reg [7:0] PTR_Read, PTR_Write;
	reg Overflow, Mode_Flag;	
									// Pointers to the Temporary Buffer
	
	initial begin
		PTR_Read <= '0;
		PTR_Write <= '0;
		Overflow <= '0;
		Count <= '1;
	end	

	always @(posedge clk_SPI) begin		
			
		if(i_SPI_valid && o_SPI_ready) begin 		// If input data is valid 
													// And Buffer is ready	
			if (Count)	begin																		
				BitConvert <= Data;
				Count <= '0;
			end			
				
			if(!Count)begin	
				
				Count <= '1;

				Buffer[PTR_Write] <= {BitConvert, Data[7:0]};//BitConvert[0][7:0]};			
													// Move Data to Buffer						
		 
				if (PTR_Write == PTR_max)		// This increments the
					PTR_Write <= '0;			// Write pointer
				else
					PTR_Write <= PTR_Write + 8'd1;
				
				if ((PTR_Write + 4'd1 == PTR_Read) || ((PTR_Write == PTR_max) && (PTR_Read == 8'd0)))
													// If Buffer is Full
					assign Overflow = '1;			// Indicate Buffer is Full
				else 
					assign Overflow = '0;								
			end				
		end
	end
	
	
					
	always @(*)  begin
	
	//CLK <= CLOCK_50;

	Mode <= Buffer[PTR_Read][16];
	Data_RAM <= Buffer[PTR_Read][15:0];
	
		if (PTR_Write == PTR_Read) begin
		
			if (Overflow) begin					// If Full Buffer 
				o_SPI_ready <= '0;		// Buffer can't be written to
				o_RAM_valid <= '1;		// Output from Buffer is valid
			end
			
			else begin
				o_SPI_ready <= '1;		// Buffer can be written to
				o_RAM_valid <= '0;		// Output isn't valid
			end
		end
		
		else  begin
			o_SPI_ready <= '1;			// Buffer Can be written to
			o_RAM_valid <= '1;			// And read from
		end
	end
	
	always @(posedge CLK) begin			// On Positive Clock Edge
	
		if(i_RAM_ready && o_RAM_valid) begin 	// If input data is valid 

			if (PTR_Read == PTR_max)		// This increments the
				assign PTR_Read = '0;			// Read pointer
			else
				assign PTR_Read = PTR_Read + 8'd1;
		end
	end
		
endmodule				
