`timescale 1ns/1ns 
`default_nettype none

module down_avg_2_tb();
//----------------------------------------------
// initialization and dut instation
    localparam N = 16;
    real p;
    logic [N-1:0] x, y;
    logic clk;

    growing_avg uut(
        .clk(clk),
        .x(x),
        .y(y)
        );
 //---------------------------------------------     
    initial begin // begin TB 
        @ (negedge clk);
        x = 0;
        @ (negedge clk);
        x = 4;
        @ (negedge clk);
        
        x = 8;
        @ (negedge clk);
        x = 8;
        @ (negedge clk);
        
        x = 20;
        @ (negedge clk);
        x = 10;
        @ (negedge clk);    
            
        for (int i=1; i<1024;i++) begin
            x=i;
            @ (negedge clk);        
        end
    end // end of TB

//------------------------------------------------
//clk   
    initial begin
        clk = 0;
        forever begin
            clk = ~clk; 
            #10;
        end 
    end
endmodule 
    
