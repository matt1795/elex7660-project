// This Module Tells the Ram when to read and write 
// By William Harkness


module Frame_Control ( 	input wire Read_Enable, Write_Enable, Mode, Busy,
		input wire [15:0] Frame_Data,
	    output reg [9:0] Row_Data, Col_Data,
		output reg Read, Write, Reset, Address_Reset, Pixel_select); 						

		wire CLK;
	
	initial begin
		Read <= '0;					// SDRAM reading and write function
		Write <= '0;			
		
		Row_Data <= 10'd0;   		// Addressing spicific pixel
		Col_Data <= 10'd0;			// Inital position is zero
		Pixel_select <= '0;			// Indicate pixel selection
		
		Reset <= '0;				// Reset the SDRAM
		Address_Reset <= '0;		// Reset Address Pointer
	end	

	always @(*) begin	
		
		//assign CLK <= CLOCK_50;
		
		if(Busy) begin
			Read <= '0;
			Write <= '0;
		end
		else if(Read_Enable) begin
			Read <= '1;
			Write <= '0;
		end
		else if(Write_Enable) begin
			Read <= '0;
			Write <= '1;
		end
		
		
	end
	
	
					
	always @(posedge CLK)  begin		 	// Here we can insert some Special
											// Modifications but for now
											// Just keep it simple.
		if (Mode) begin
			Address_Reset <= '1;
		end
		else begin
			Address_Reset <= '0;
		end
	end
endmodule