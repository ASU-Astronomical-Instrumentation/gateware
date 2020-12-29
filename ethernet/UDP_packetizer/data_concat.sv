module data_concat #(
    parameter BW : integer =  18;
    parameter N_PRL : integer = 4;
    parameter BW_out : integer = 8;
) (
    input wire clk,srst_n,
    input logic [0:N_PRL-1] [0:BW-1] x,
    output logic [0:BW*N_PRL/BW_out -1] [0:BW_out-1] y
)

logic [BW*N_PRL-1:0] largex;

always_ff @ (posedge clk)
    if(~rst)
        largex <= 'd0;
    else
        largex <= {x[3], x[2], x[1], x[0]};

genvar i;
generate
    for (i=0; i<BW*N_PRL/BW_out-1; i++) begin
        y[i] <= x[BW_out*(i+1)-1:BW_out*i-1];
endgenerate

endmodule