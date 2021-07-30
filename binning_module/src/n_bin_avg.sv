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
            input wire clk,
            input wire fft_valid,
            input logic [BINS-1:0] [N-1:0] in_data,
            output logic [BINS-1:0] [N-1:0] out_data
        );

    
    genvar i;
    generate
        for (i = 0; i <BINS;i++) 
            begin: generate_avg
                growing_avg u_growing_avg
                    (.clk(clk),
                    .x(in_data[i]),
                    .y(out_data[i])
                    );
        end
    endgenerate 
        
endmodule