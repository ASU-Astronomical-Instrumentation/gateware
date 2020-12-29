module data_concat_tb();
    
    logic clk, rst;
    logic [3:0] [17:0] x;
    logic [8:0] [7:0] y;

data_concat uut(
    .clk(clk)
    .rst(rst)
    .x(x)
    .y(y)
);

initial begin
    rst=1
    #35
    rst=0
    x[0]= 18'hFFFF
    x[1]= 18'h0000
    x[2]= 18'hFFFF
    x[3]= 18'h0000
    #20
    x[0]= 18'h0033
    x[1]= 18'hCC00
    x[2]= 18'h0033
    x[3]= 18'hCC00
end 

    initial begin
        clk = 0;
        forever begin
            clk = ~clk; 
            #10;
        end 
    end


endmodule