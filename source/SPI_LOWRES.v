// This Module Takes 8 bit input from SPI Signal and stores the data on temporary buffer
// Called Buffer. It will then send 16 bit data to the RAM.
// By William Harkness


module SPI ( 	input wire [8:0] Data,
				input wire [7:0] Row_Select,
				input wire clk_SPI, Next_Line, CLK, reset,
				output reg Data_Valid,
				output reg [7:0] Data_Frame); 
				
	parameter PTR_Max_Row =  119;
	parameter PTR_Max_Col =  159;

	
	reg [7:0] Buffer [PTR_Max_Row:0] [PTR_Max_Col:0] ;		// 320 pixal = one line
			

	reg [8:0] PTR_Read_Col, PTR_Write_Row, PTR_Write_Col;
	reg Full, Line_Flag;
	reg clk_SPI_next, Doubler;
	reg [8:0] Data_next;	
	
											// Pointers to the Temporary Buffer
	
	initial begin
		PTR_Read_Col <= 8'd0;
		PTR_Write_Col <= 8'd0;
		PTR_Write_Row <= 8'd0;
		Data_Frame <= 8'd0;
		Data_next <= 8'd0;
		Full = 1'b0;
		Line_Flag = 1'b0;
		Data_Valid = 1'b1;
		Doubler = 1'b0;
	end	
		
	
	always @(posedge clk_SPI_next) begin			
		
		Buffer[PTR_Write_Row][PTR_Write_Col] <= Data_next[7:0];			
															// Move Data to Buffer	
													
		if (((PTR_Write_Col == PTR_Max_Col) && (PTR_Write_Row == PTR_Max_Row)) && ~Data_next[8]);
		
		
		else if ((PTR_Write_Col == PTR_Max_Col) || Data_next[8]) begin	
															// This increments the
				
			PTR_Write_Col = 8'd0;							// Write pointer
				
			if (Data_next[8])								
				PTR_Write_Row = 8'd0;						
				
			else if (PTR_Write_Row == PTR_Max_Row)
				PTR_Write_Row = PTR_Max_Row;
			
			else
				PTR_Write_Row = PTR_Write_Row + 8'd1;
					
		end
		else
			PTR_Write_Col = PTR_Write_Col + 8'd1;							
						
	end
	
	
					
	always @(*)  begin
	
		if ((PTR_Write_Col == PTR_Max_Col) && (PTR_Write_Row == PTR_Max_Row))
			Full = '1;
		
		if(Full) 
			Data_Frame <= Buffer[Row_Select[7:1]] [PTR_Read_Col];
		
		else
			Data_Frame <= 8'd0;
		
	end
	
	
	always @(posedge CLK) begin		
	
		clk_SPI_next <= clk_SPI;
		Data_next <= Data;
		
		
		if(Next_Line && ~reset)
			Line_Flag = 1'b1;
		
		if(Next_Line || Line_Flag || reset) begin 			// Video wants output
		
			if( ~Doubler && ~reset)
				Doubler = 1'b1;

			else if ((PTR_Read_Col == PTR_Max_Col) || reset) begin
				PTR_Read_Col = 8'd0;					
				Line_Flag = 0'b0;
				Doubler = 1'b0;
			end
			
			else begin
				PTR_Read_Col = PTR_Read_Col + 8'd1;	
				Doubler = 1'b0;
			end
		end
	end
		
endmodule				

