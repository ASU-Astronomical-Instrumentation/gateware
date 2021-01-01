`timescale 1ns/1ns

module data_concat #(
    parameter BW =  18,
    parameter N_PRL = 4,
    parameter BW_out = 8
) (
    input wire clk,srst_n,
    input logic [BW-1:0] x[N_PRL],
    output logic [BW_out-1:0] y[BW*N_PRL/BW_out] 
);

logic [BW*N_PRL-1:0] largex;

integer i;
always_ff @ (posedge clk or negedge srst_n) begin
    if(~srst_n) 
        largex <= 'b0;
    else
        for (i=0; i<N_PRL; i=i+1)
	        largex[BW*(3-i) +: BW] = x[i];
    	foreach (y[j]) 
            y[j]=largex[BW_out*(BW*N_PRL/BW_out-1-j) +: BW_out];
end
endmodule