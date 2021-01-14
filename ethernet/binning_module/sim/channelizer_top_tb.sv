`timescale 1ns/1ns 
`default_nettype none

module channelizer_top_tb();

localparam BINS = 4;
localparam N = 16;
localparam SUM_WIDTH = 32;
localparam N_out=8;

localparam [N-1:0] dat[31:0] = {
    16'h9258,
    16'h0868,
    16'h6ddc,
    16'h7b9a,
    16'h940e,
    16'h03dd,
    16'h34d3,
    16'h767c,
    16'hd046,
    16'h7dd6,
    16'hd2e7,
    16'h471c,
    16'ha75a,
    16'hcf95,
    16'h2915,
    16'h08df,
    16'h855b, //spec 4
    16'h7d87,
    16'h53f9,
    16'h138b,
    16'h4010, //spec 3
    16'hf3e1,
    16'hf3fc,
    16'hbeed,
    16'hff2f, //spec 2
    16'h5c85,
    16'h0b79,
    16'h6bb0,
    16'hdc44, //spec 1
    16'h2392,
    16'h9a7b,
    16'h5af7
};


logic clk, arest_n,fft_ready;
logic [N-1:0] in_data;
logic [7:0] N_AVGS_in;
logic valid;
logic [BINS*N/N_out-1:0] [N_out-1:0] out_data;

/********************************************
*           Device Under Test               *
********************************************/
channelizer_top #( 
	.N(N),
	.N_out(N_out),
	.SUM_WIDTH(SUM_WIDTH),
	.BINS(BINS) 
	)
	dut (
	.clk(clk),
	.arest_n(arest_n),
    .fft_ready(fft_ready),
	.in_data(in_data),
    .N_AVGS_in(N_AVGS_in),
	.valid(valid),
	.out_data(out_data)
	);

initial begin
/********************************************
*           Beginning TestBench             *
********************************************/
    N_AVGS_in=8'd1;
    arest_n='b0;
    valid='b0;
    fft_ready='b0;
    in_data=8'h00;
    #17;
    arest_n='b1;
    #27;

    for(int j=0;j<8;j++) begin
        @ (posedge clk)
        fft_ready='b1;
        for (int i =0; i<BINS; i++) begin
            in_data=dat[i+j*BINS];
            @ (posedge clk);
            fft_ready = 0;
    	end
	#5;
    end

    fft_ready='b0;
    in_data=8'h00;
    #27;
    arest_n='b0;

end
    initial begin
        clk = 1;
        forever begin
            clk = ~clk; 
            #10;
        end 
    end
endmodule