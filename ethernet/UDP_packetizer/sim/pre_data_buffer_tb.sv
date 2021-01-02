// Kathryn Chamberlin, Ryan Stephenson
// 30 Sept 2020
`timescale 1ns/1ns 
`default_nettype none

module pre_data_buffer_tb();

localparam N = 8;
localparam data_points=5;
localparam N_specs=3;
logic [N-1:0] data_in [data_points];
logic [N-1:0] data_out [data_points];
logic   data_clk, eth_clk, rst, sclr_n,
        rready, rready, empty,
        full, wvalid, rvalid,
        fill_count;

pre_data_buffer #(
        .N(N),
        .data_points(data_points),
        .N_specs(N_specs)
    )
    dut(
      .data_clk(data_clk),    
      .eth_clk(eth_clk),    
      .sclr_n(sclr_n),    
      .data_in(data_in),    
      .wready(wready),
      .rready(rready),
      .data_out(data_out),    
      .empty(empty),    
      .full(full),    
      .wvalid(wvalid),
      .rvalid(rvalid),
      .fill_count(fill_count)    
    );
    
initial begin
    sclr_n='b0;
    wready='b0;
    rready='b0;
    data_in= '{8'hc0,8'hff,8'hee,8'h0f,8'hf0};
    #25;
    sclr_n='b1;
    #20;
    rready='b1;
    #15;
    rready='b0;
    wready='b1;
    data_in='{8'h00,8'h00,8'h00,8'h00,8'h00};

end

initial begin // pfb clock
   eth_clk = 0;
    forever begin
        eth_clk = ~eth_clk; 
        #5;
    end 
end

initial begin // ethernet clock
   data_clk = 0;
    forever begin
        data_clk = ~data_clk; 
        #7;
    end 
end
endmodule 
    