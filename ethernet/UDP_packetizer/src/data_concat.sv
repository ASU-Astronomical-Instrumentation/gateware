`timescale 1ns/1ns

module data_concat #(
    parameter BW =  18, // bit width
    parameter N_PRL = 4, // number of parallel IQ values
    parameter BW_out = 8 // output bit width (ethernet input)
) (
    input wire clk, srst_n,
    input wire data_ready,
    output wire data_valid,
    input logic [N_PRL-1:0][BW-1:0] x,
    output logic [BW*N_PRL/BW_out-1:0][BW_out-1:0] y 
);

logic [BW*N_PRL-1:0] largex;
integer i;

always_ff @ (posedge clk) begin
    if(~srst_n) 
        y <= 'b0;
        data_valid <= 'b0;
    else begin
        if (data_ready == 1)
            data_valid = 'b1;
            for (i=0; i<N_PRL; i=i+1)
    	        largex[BW*i +: BW] = x[i];
        	foreach (y[j]) 
                y[j] = largex[BW_out*j +: BW_out];
        else 
            y <= 'b0;
            data_valid <= 'b0;
      end
end
endmodule