// This Module organizes the addresses being addressed. 
// By William Harkness


module Address_Control ( 	input wire Read, Write, Mode, Busy, Reset,
		input wire [9:0] Row_Data, Col_Data,
		output reg [19:0] R_Address, W_Address); 
				
									
	reg R_Flag, W_Flag;			
	reg [19:0] R_Address_Buf;
	reg [19:0] W_Address_Buf;
									
	parameter Max_Address = 76800;		// 320 x 240

	
	initial begin
		R_Flag <= '0;					// Flags for self incrementation
		W_Flag <= '0;			
		
		R_Address_Buf <= 10'd0;   		// Read Row Address
		W_Address_Buf <= 10'd0;			// Write Row Address
		
		
		R_Address <= 20'd0;				// Address Outputs
		W_Address <= 20'd0;
	
	end	

	always @(*) begin	
		if(Read) 					// If Reading from SDRAM
			R_Flag = '1;			// Indicate with flag
		else
			if(Busy)				// If SDRAM is busy
				R_Flag <= R_Flag;
									// Keep flag constant
			else
				R_Flag <= 0;		// Reset Flag
							
		if(Write) 					// Same with Write flag
			W_Flag = '1;
		else
			if(Busy)
				W_Flag <= W_Flag;
			else
				W_Flag <= 0;
		
		if(Mode && !Reset) begin
			W_Address <= 320 * (Row_Data - '1) + Col_Data;
		end	
									// Only statement with some computations
									// For individual pixel selections
		
		if(Reset) begin
			W_Address <= '0;		// Clear addresses on reset
			R_Address <= '0;
		end						
		else begin
			W_Address <= W_Address_Buf;
			R_Address <= R_Address_Buf;
		end
			
	end
	
	
					
	always @(negedge W_Flag)  begin		// When Write function is complete
		if(W_Address == Max_Address)	// Auto Incrementation
			W_Address_Buf <= W_Address;
		else
			W_Address_Buf = W_Address + '1;
	
	
	end
		
	always @(negedge R_Flag)  begin		// When Read function is Complete
		if(R_Address == Max_Address)	// Auto Incremetation
			R_Address_Buf <= R_Address;
		else
			R_Address = R_Address + '1;
		
	end
endmodule				
