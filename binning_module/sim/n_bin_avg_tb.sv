// Kathryn Chamberlin, Ryan Stephenson
// 30 Sept 2020
`timescale 1ns/1ns 
`default_nettype none

module n_bin_avg_tb();

    localparam N = 16;
    localparam SUM_WIDTH = 128;
    logic [3:0] [SUM_WIDTH-1:0] y;
    logic [3:0] [N-1:0] x;
    logic clk, valid;

    N_bin_avg uut(
        .clk(clk),
        .in_data(x),
        .out_data(y),
        .fft_valid(valid)
        );
        
    initial begin
        //x = 16'd40;
        //@ (posedge clk);  
        x[0] = 16'd10;
        $display("x of 0", x[0]);
        //@ (posedge clk); 
        x[1] = 16'd30;
        //@ (posedge clk);
        x[2] = 16'd20;
        //@ (posedge clk);
        x[3] = 16'd30;
        @ (posedge clk);   
        $display("growing uut 0 ", uut.generate_avg[0].u_growing_avg.x);
        $display("growing uut 3 %h", uut.generate_avg[3].u_growing_avg.x);
        @ (posedge clk);
        x = 128'hFFFFAAAABBBBCCCC;
        @ (posedge clk);
        $display("growing uut 0 %h", uut.generate_avg[0].u_growing_avg.x);
        $display("growing uut 3 %h", uut.generate_avg[3].u_growing_avg.x);
    end
    
    initial begin
        clk = 0;
        forever begin
            clk = ~clk; 
            #10;
        end 
    end
endmodule 