// Kathryn Chamberlin, Ryan Stephenson
// 30 Sept 2020
`timescale 1ns/1ns 
`default_nettype none

module bin_collection_wrapper_tb();

    localparam BINS = 4;
    localparam N = 16;
    localparam SUM_WIDTH = 128;
    localparam N_AVGS = 7;
    logic [BINS-1:0] [N-1:0] x;
    logic [BINS-1:0] [N-1:0] y;
    logic [N-1:0] in_data;
    logic clk, valid, areset_n;

    N_bin_avg_wrapper
        #(
        .N(N),
        .N_AVGS(N_AVGS),
        .SUM_WIDTH(SUM_WIDTH),
        .BINS(BINS)
        ) uut(
        .clk(clk),
        .areset_n(areset_n),
        .in_data(in_data),
        .out_data(y),
        .fft_valid(valid)
        );
    
    //-------------------------------------
    //      TEST STIMULOUS
    //-------------------------------------
    initial begin
        areset_n = 0;
        valid = 0;
        #10;
        areset_n = 1;
        valid = 1;
        for (int i=0; i<1024;i++) begin
                in_data=i;
                @ (negedge clk); 
                valid = 0;       
            end
    
    end
    
    //------------------------------------
    //          CLOCK
    //------------------------------------
    initial begin
        clk = 1;
        forever begin
            clk = ~clk; 
            #10;
        end 
    end
    
endmodule 