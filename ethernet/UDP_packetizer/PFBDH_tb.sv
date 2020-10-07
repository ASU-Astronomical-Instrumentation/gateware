// Kathryn Chamberlin, Ryan Stephenson
// 30 Sept 2020
`timescale 1ns/1ns 
`default_nettype none

module PFBDH_tb();

    localparam N = 16;
    logic [N-1:0] x, y;
    logic [2:0] N_AVGS_in;
    logic clk, valid, new_dat;

    pfb_data_handler dut(
            .wclk(wclk)
            .rclk(rclk)
            .wdata(wdata)
            .rdata(rdata)
            .waddr(waddr)
            .raddr(raddr)
            .rready(rready)
            .bramrdy(bramrdy)
            .clr(clr)
            .done(done)
        );
        
    initial begin


    end

    initial begin 
        clk = 0;
        forever begin
            clk = ~clk; 
            #10;
        end 
    end

endmodule 
    
