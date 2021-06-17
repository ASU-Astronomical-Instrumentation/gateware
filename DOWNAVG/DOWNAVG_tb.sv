`timescale 1ns/1ns 
`default_nettype none

module down_avg_tb();

    localparam N = 14;
    logic [N-1:0] x, y, x1, x2;
    logic clk, ready, valid, rst;

    AVGDOWNrev_i uut(
        .clk(clk),
        .ready(ready),
        .valid(valid),
        .rst(rst),
        .x(x),
        .y(y)
        );
        
    initial begin
        x = 14'b0;
        valid = 0;
        ready = 0;
        rst = 1;
        #20;
        
        rst = 0;
        
        #20;
        
        x = 14'b00000001111111;
        x1 = x;
        @ (posedge clk);
        ready = 1;
        @ (posedge clk);
        ready = 0;
        
        #10;
        x = 14'b00000000000111;
        x2= x;
        ready = 1;
        @ (posedge clk);
        ready = 0;
        #10;
        assert (y == ((x1+x2)/2))
            else begin
                $error("wrong output");
            end
        assert (valid == 1)
            else begin 
                $error("output not valid");
            end 
        //#10;
        
        //-------------------------------------
        @ (posedge clk);
        rst = 1;
        @ (posedge clk);
        rst = 0;
        @ (posedge clk);
        x = 14'b00000001110000;
        x1 = x;
        ready = 1;
        @ (posedge clk);
        ready = 0;
        
        #10;
        x = 14'b00000000111111;
        x2= x;
        ready = 1;
        @ (posedge clk);
        ready = 0;
        #10;
        assert (y == ((x1+x2)/2))
            else begin
                $error("wrong output");
            end
        assert (valid == 1)
            else begin 
                $error("output not valid");
            end 
        #10;
        
    end
    
    initial begin
        clk = 0;
        forever begin
            clk = ~clk; 
            #10;
        end 
    end
endmodule 
    
