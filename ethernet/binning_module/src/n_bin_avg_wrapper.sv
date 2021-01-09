/**********************************************************
7 October 2020
1 Jan 2021
K. Chamberlin R. Stephenson
Description: bin averaging wrapper 
***********************************************************/

`timescale 1ns/1ns 
//`default_nettype none

module N_bin_avg_wrapper #(
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
            output logic valid_out,
            output logic [BINS*N/N_out-1:0] [N_out-1:0] out_data,
        );

    //******************* internal registers ********************
    logic [BINS-1:0] [SUM_WIDTH-1:0] fft_spec;
    logic i_bin_c_valid;
    
    //**********************************************************
    //          GENERATE PARALLEL AVERAGING MODULES
    //**********************************************************
    genvar i;
    generate
        for (i = 0; i <BINS;i++) 
            begin: generate_avg
                growing_avg #(
                    .N(N),
                    .N_AVGS(N_AVGS),
                    .SUM_WIDTH(SUM_WIDTH)
                    ) 
                    u_growing_avg (
                    .clk(clk),
                    .valid(valid),
                    .x(fft_spec[i]),
                    .N_AVGS_in(N_AVGS),
                    .new_data(),
                    .y(out_data[i])
                    );
        end
    endgenerate 
    
    //**********************************************************
    //          COLLECT FFT BINS INTO ARRAY
    //**********************************************************
    N_bin_collection #(
        .N(N),
        .N_AVGS(N_AVGS),
        .SUM_WIDTH(SUM_WIDTH),
        .BINS(BINS)
        ) u_N_bin_collection
        (.clk(clk),
        .arest_n(arest_n),
        .fft_ready(fft_ready),
        .in_data(in_data),
        .out_data(fft_spec),
        .output_valid(i_bin_c_valid)
        );


/***********************************************************
*               RE-ARRANGE DATA WIDTH FOR ETHERNET
***********************************************************/
    data_concat #(
        .BW(SUM_WIDTH),
        .N_PRL(BINS),
        .BW_out(N_out)
    )
    u_data_concat (
        .clk(clk),
        .arest_n(srst_n),
        .data_ready(i_bin_c_valid),
        .data_valid(valid_out),
        .x(fft_spec),
        .y(out_data)
    );
        
endmodule