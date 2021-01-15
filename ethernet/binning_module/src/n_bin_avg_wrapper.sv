/**********************************************************
Created : 7 October 2020
Modified : 1 Jan 2021
K. Chamberlin R. Stephenson
Description: bin averaging wrapper 
***********************************************************/

`timescale 1ns/1ns 
//`default_nettype none

module N_bin_avg_wrapper #(
            parameter N = 16,
            parameter N_out = 8,
            parameter SUM_WIDTH = 32,
            parameter BINS = 4
        )
        (
            input wire clk, arest_n,
            input wire fft_ready,
            input wire [N-1:0] in_data,
            input wire [7:0] N_AVGS_in, //this is hardcoded in source
            output logic valid,
            output logic [BINS*N/N_out-1:0] [N_out-1:0] out_data
        );

    //******************* internal registers ********************
    logic [BINS-1:0] [N-1:0] fft_spec,avg_fft_spec;
    logic [BINS-1:0] i_avg_valid_BINS;
    logic i_bin_c_valid, i_avg_valid;
    
    
    
    //**********************************************************
    //          COLLECT FFT BINS INTO ARRAY
    //**********************************************************
    N_bin_collection #(
        .N(N),
        .BINS(BINS)
        ) u_N_bin_collection
        (.clk(clk),
        .areset_n(arest_n),
        .fft_valid(fft_ready),
        .in_data(in_data),
        .out_data(fft_spec),
        .output_valid(i_bin_c_valid)
        );

    /***********************************************************
    *          GENERATE PARALLEL AVERAGING MODULES             *
    ***********************************************************/
    genvar i;
    generate
        for (i = 0; i <BINS;i++) 
            begin: growing_avg_signed
                growing_avg #(
                    .N(N),
                    .SUM_WIDTH(SUM_WIDTH)
                    ) 
                    u_growing_avg (
                    .clk(clk),
                    .valid(i_bin_c_valid),
                    .x(fft_spec[i]),
                    .N_AVGS_in(N_AVGS_in),
                    .new_dat(i_avg_valid_BINS[i]),
                    .y(avg_fft_spec[i])
                    );
        end
    endgenerate 

    assign i_avg_valid = i_avg_valid_BINS[0] & i_avg_valid_BINS[1] & i_avg_valid_BINS[2] & i_avg_valid_BINS[3];

/***********************************************************
*               RE-ARRANGE DATA WIDTH FOR ETHERNET         *
***********************************************************/
    data_concat #(
        .BW(N),
        .N_PRL(BINS), // I don't think this is right
        .BW_out(N_out)
    )
    u_data_concat (
        .clk(clk),
        .arest_n(arest_n),
        .data_ready(i_avg_valid),
        .data_valid(valid),
        .x(avg_fft_spec),
        .y(out_data)
    );     
endmodule