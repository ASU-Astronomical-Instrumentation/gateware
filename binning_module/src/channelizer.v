
module channelizer_top #(
            parameter N = 16,
            parameter N_out = 8,
            parameter N_AVGS = 7, // -- Total Averages = 2^N_AVGS
            parameter SUM_WIDTH = 32,
            parameter BINS = 4
        )
        (
            input wire clk, arest_n,
            input wire fft_ready,
            input wire [BINS-1:0] [N-1:0] in_data,
            output wire valid,
            output reg [BINS*N/N_out-1:0] [N_out-1:0] out_data
        );
        
        N_bin_avg_wrapper #(.N(N),.N_out(N_out),.N_AVGS(N_AVGS),.SUM_WIDTH(SUM_WIDTH),.BINS(BINS)) 
        u0(
        .clk(clk),
        .arest_n(arest_n),
        .in_data(in_data),
        .valid(valid),
        .out_data(out_data)
        );
endmodule;
