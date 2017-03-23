// This Module organizes the addresses being addressed. 



module SPI ( 	input logic Read, Write, Mode, Busy, Reset,
	    		input logic [15:0] BitData,
			output logic [19:0] R_Address, W_Address); 
				
									
	reg R_Flag, W_Flag;			
	wire [9:0] R_Address_Row_Buf, R_Address_Col_Buf;
	wire [9:0] W_Address_Row_Buf, W_Address_Col_Buf;
									
	parameter Max_Address = 307200;
	
	initial begin
		R_Flag <= '0;			// Flags for self incrementation
		W_Flag <= '0;			
		
		R_Address_Row_Buf <= 10'd0;   	// Read Row Address
		R_Address_Col_Buf <= 10'd0;	// Read Column Address
		W_Address_Row_Buf <= 10'd0;	// Write Row Address
		W_Address_Col_Buf <= 10'd0;	// Write Column Address
		
		R_Address <= 20'd0;		// Address Outputs
		W_Address <= 20'd0;
	
	end	

	always @(*) begin	
		if(Read) 			// If Reading from SDRAM
			R_Flag = '1;		// Indicate with flag
		else
			if(Busy)		// If SDRAM is busy
				R_Flag <= R_Flag;
						// Keep flag constant
			else
				R_Flag <= 0;	// Reset Flag
							
		if(Write) 			// Same with Write flag
			W_Flag = '1;
		else
			if(Busy)
				W_Flag <= W_Flag;
			else
				W_Flag <= 0;
		
		
		if(Reset) begin
			W_Address <= '0;
			R_Address <= '0;
		end
		else begin
			W_Address <= {W_Address_Row_Buf[9:0], W_Address_Col_Buf[9:0]};
			R_Address <= {R_Address_Row_Buf[9:0], R_Address_Col_Buf[9:0]};
		end
			
	end
	
	
					
	always @(negedge W_Flag)  begin		// When Write function is complete
		if(W_Address == Max_Address)	// Auto Incrementation
			W_Address_Buf <= '0;
		else
			W_Address_Buf = W_Address + '1;
		
	end
		
	always @(negedge R_Flag)  begin		// When Read function is Complete
		if(R_Address == Max_Address)	// Auto Incremetation
			R_Address <= '0;
		else
			R_Address = R_Address + '1;
		
	end
endmodule				
