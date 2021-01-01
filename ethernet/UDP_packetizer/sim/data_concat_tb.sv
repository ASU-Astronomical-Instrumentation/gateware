`timescale 1ns/1ns
`default_nettype none

module data_concat_tb();
    
    logic clk, srst_n;
    logic [3:0][17:0] x ;
    logic [8:0][7:0]  y ;

data_concat uut(
    .clk(clk),
    .srst_n(srst_n),
    .x(x),
    .y(y)
);

initial begin
    srst_n=1'b0;
    #35;
    srst_n=1'b1;
    x[0]= 18'h2560a;
    x[1]= 18'h0000;
    x[2]= 18'hFFFF;
    x[3]= 18'h0000;
    #20;
    x[0]= 18'h2560a;
    x[1]= 18'h19b20;
    x[2]= 18'h3d272;
    x[3]= 18'h21073;
end 

    initial begin
        clk = 1'b0;
        forever begin
            clk = ~clk; 
            #10;
        end 
    end
endmodule