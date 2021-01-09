
module bin_counter #(
	parameter BINS = 512	)
	(
        input clk, areset_n,
        input fft_valid, 
        output logic [31:0] bin_num
        );
    
    logic start_select;
   
    always_ff @ (posedge clk or negedge areset_n)
        if (~areset_n)
            bin_num <= 32'd0;
        else if (bin_num == BINS)
		bin_num <=32'd0;
	else 
            bin_num <= bin_num + 1;
endmodule 