/**********************************************************
7 October 2020
Description: bin averaging wrapper 
***********************************************************/

`timescale 1ns/1ns 
//`default_nettype none

module N_bin_avg #(
            parameter N = 16,
            parameter N_AVGS = 7, // -- Total Averages = 2^N_AVGS
            parameter SUM_WIDTH = 128,
            parameter BINS = 4
        )
        (
            input wire clk, arest_n,
            input wire fft_valid,
            input logic [BINS-1:0] [N-1:0] in_data,
            output logic [BINS-1:0] [N-1:0] out_data
        );

    //******************* internal registers ********************
    logic [BINS-1:0] [N-1:0] fft_array;
    
    genvar i;
    generate
        for (i = 0; i <BINS;i++) 
            begin: generate_avg
                growing_avg #(
                    .N(N),
                    .N_AVGS(N_AVGS),
                    .SUM_WIDTH(SUM_WIDTH)
                    ) u_growing_avg
                    (.clk(clk),
                    .x(fft_array[i]),
                    .y(out_data[i])
                    );
        end
    endgenerate 
    
    N_bin_collection #(
        .N(N),
        .N_AVGS(N_AVGS),
        .SUM_WIDTH(SUM_WIDTH),
        .BINS(BINS)
        ) u_N_bin_collection
        (.clk(clk),
        .arest_n(arest_n),
        .fft_valid(fft_valid),
        .in_data(in_data),
        .out_data(fft_array)
        );
        
endmodule