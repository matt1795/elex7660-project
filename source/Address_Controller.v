// This Module organizes the addresses being addressed. 



module SPI ( 	input logic Read, Write, Mode, Busy, Reset,			
				output logic [19:0] R_Address, W_Address); 
				
									
	reg R_Flag, W_Flag;				
	wire [19:0] R_Address_Buf, W_Address_Buf;
									
	parameter Max_Address = 307200;
	
	initial begi
		R_Flag <= '0;
		W_Flag <= '0;
		R_Address <= 20'h00000;
		W_Address <= 18'h00000;
	end	

	always @(*) begin	// On Positive Clock Edge
		
		if(Read) 
			R_Flag = '1;
		else
			if(Busy)
				R_Flag <= R_Flag;
			else
				R_Flag <= 0;
		
		if(Write) 
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
			W_Address <= W_Address_Buf;
			R_Address <= R_Address_Buf;
		end
			
	end
	
	
					
	always @(negedge W_Flag)  begin
	
		if(W_Address == Max_Address)
			W_Address_Buf <= '0;
		else
			W_Address_Buf = W_Address + '1;
		
	end
		
	always @(negedge R_Flag)  begin
		if(R_Address == Max_Address)
			R_Address <= '0;
		else
			R_Address = R_Address + '1;
		
	end
endmodule				
