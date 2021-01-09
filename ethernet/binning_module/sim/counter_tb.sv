`timescale 1ns/1ns 
`default_nettype none

module counter_tb();
    logic clk, reset;
    logic fft_valid;
    logic [31:0] bin_num;
    
    bin_counter uut
        (.clk(clk),
        .areset_n(reset),
        .fft_valid(fft_valid),
        .bin_num(bin_num)
        );
    
    initial begin  
        reset = 1'b0;
        #10;
        reset = 1'b1;
        fft_valid = 1'b0;
        @ (posedge clk);
        fft_valid = 1'b1;
        @ (posedge clk);
        fft_valid = 1'b0;
    end
        
        
    initial begin
        clk = 0;
        forever begin
            clk = ~clk; 
            #10;
        end 
    end
endmodule 
