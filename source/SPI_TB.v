// SPI_tb.sv - testbench for ELEX 7660 201710 Lab 3


module SPI_tb ;

   reg clk = '0;
   wire Mode_OUT, o_SPI_ready, o_RAM_valid;
   wire [15:0] Data_RAM;
   reg [7:0] Data_SPI;
   reg i_SPI_valid, Mode_IN, i_RAM_ready;

   SPI SPI_TEST (
   .Data ({Mode_IN, Data_SPI}),
   .clk_SPI (clk),
   .i_SPI_valid (i_SPI_valid),
   .i_RAM_ready (i_RAM_ready),
   .CLK (clk),
   .o_SPI_ready (o_SPI_ready),
   .o_RAM_valid (o_RAM_valid),
   .Mode (Mode_OUT),
   .Data_RAM (Data_RAM));
   

   initial begin
		
		Data_SPI = 8'h00;
		i_SPI_valid = '0;
		Mode_IN = '0;
		i_RAM_ready = '0;
      
		repeat(2) @(posedge clk) ;
		
		i_SPI_valid = '1;
		
		repeat(400) begin
			@(posedge clk) ;
			Data_SPI = Data_SPI + 8'd1;
		end
		
			Data_SPI = 8'hff;
			Mode_IN = '1;
			i_RAM_ready = 9'd1;
		
		
		
		repeat(400) begin
			@(posedge clk);
			Data_SPI = Data_SPI - 8'd1;
		end


		$stop ;
      // $finish ;
   end

   // clock
   always
     #(10) assign clk = ~clk ;
   
endmodule      

