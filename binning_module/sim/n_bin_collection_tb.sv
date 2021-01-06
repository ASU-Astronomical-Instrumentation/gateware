// Kathryn Chamberlin, Ryan Stephenson
// 30 Sept 2020
`timescale 1ns/1ns 
`default_nettype none

module n_bin_collection_tb();

    localparam BINS = 4;
    localparam N = 16;
    localparam SUM_WIDTH = 128;
    logic [BINS-1:0] [N-1:0] y;
    logic [N-1:0] in_data;
    logic clk, valid, areset_n;
    logic [2:0] N_AVGS_in;

    N_bin_avg_wrapper
        #(.N(N),
        .SUM_WIDTH(SUM_WIDTH)
        )      uut(
        .clk(clk),
        .areset_n(areset_n),
        .in_data(in_data),
        .N_AVGS_in(N_AVGS_in),
        .out_data(y),
        .fft_valid(valid)
        );
    
    //-------------------------------------
    //      TEST STIMULOUS
    //-------------------------------------
    initial begin
        areset_n = 0;
        valid = 0;
        N_AVGS_in = 3'd1;
        #30;
        areset_n = 1;
        @ (posedge clk);
        valid = 1;
        for (int i=10; i<14;i++) begin
                in_data=i;
                @ (posedge clk); 
                valid = 0;       
            end
        
        valid = 1;
        for (int i=5; i<9;i++) begin
                in_data=i;
                @ (posedge clk); 
                valid = 0;       
        end

        valid = 1;
        for (int i=15; i<19;i++) begin
                in_data=i;
                @ (posedge clk); 
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