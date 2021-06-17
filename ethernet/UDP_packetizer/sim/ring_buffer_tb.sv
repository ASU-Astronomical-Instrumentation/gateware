// Kathryn Chamberlin, Ryan Stephenson
// 30 Sept 2020
`timescale 1ns/1ns 
`default_nettype none

module ring_buffer_tb();

localparam N = 8;
logic [N-1:0] wr_data, rd_data;
logic   wclk, rclk, rst, wr_en,
        rd_en, rd_valid, emptied,
        empty_next, filled, full_next,
        fill_counter;

ring_buffer dut(
        .wclk(wclk),
        .rclk(rclk),
        .rst(rst),

        .wr_en(wr_en),
        .wr_data(wr_data),

        .rd_en(rd_en),
        .rd_valid(rd_valid),
        .rd_data(rd_data),

        .emptied(emptied),
        .empty_next(empty_next),

        .filled(filled),
        .full_next(full_next),

        .fill_counter(fill_counter)
    );
    
initial begin
    // init
    rst = 1;
    rd_en = 0;
    rd_valid = 0;
    wr_data=0;
    wr_en=0;
    #35;
    // load ram
    rst = 0;
    wr_en = 1;
    for (int i=0; i<1024; i++) begin
        wr_data = i;
        @ (posedge wclk);
    end 
    @ (posedge wclk);
    // unload
    rd_en = 1;
    rd_valid = 1;



end

initial begin // pfb clock
   wclk = 0;
    forever begin
        wclk = ~wclk; 
        #10;
    end 
end

initial begin // ethernet clock
   rclk = 0;
    forever begin
        rclk = ~rclk; 
        #3;
    end 
end
endmodule 
    
