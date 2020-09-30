// Kathryn Chamberlin, Ryan Stephenson
// 30 Sept 2020
`timescale 1ns/1ns 
`default_nettype none

module down_avg_2_tb();

    localparam N = 16;
    logic [N-1:0] x, y;
    logic clk;

    growing_avg uut(
        .clk(clk),
        .x(x),
        .y(y)
        );
        
    initial begin
        x = 16'b0;
        @ (posedge clk);    
            
        for (int i=0; i<1024;i++) begin
            x=i;
            @ (posedge clk);        
        end
end
//        @ (posedge clk);
//        x = 16'd10;
 
      
//        @ (posedge clk);
//        x = 16'd20;
//      end
   
    initial begin
        clk = 0;
        forever begin
            clk = ~clk; 
            #10;
        end 
    end
endmodule 
    
