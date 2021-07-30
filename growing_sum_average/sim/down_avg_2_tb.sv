// Kathryn Chamberlin, Ryan Stephenson
// 30 Sept 2020
`timescale 1ns/1ns 
`default_nettype none

module down_avg_2_tb();

    localparam N = 16;
    logic [N-1:0] x, y;
    logic [2:0] N_AVGS_in;
    logic clk, valid, new_dat;

    growing_avg uut(
        .clk(clk),
        .valid(valid),
        .x(x),
        .N_AVGS_in(N_AVGS_in),
        .new_dat(new_dat),
        .y(y)
        );
        
    initial begin
        // init
        N_AVGS_in = 1;
        valid=0;
        #20 
        valid=1;
        @(posedge clk); 

        //---------------------------------------------------------
        //                  Test 1
        //  simple test with 4 values; avg by 2x
        //---------------------------------------------------------

        
        x = 16'b0;
        @(posedge clk);  
        x = 16'd10;
        @ (posedge clk); 

        x = 16'd20;
        @(posedge clk);
        x = 16'd20;
        @(posedge clk);
	    valid=0;
	    @(posedge clk);
       
        //---------------------------------------------------------
        //                       Test 2
        //      test for different average lengths with counter
        //---------------------------------------------------------
        
        for(int j=1; j<=7; j++) begin    
            N_AVGS_in = j;
            x=0;
            @ (posedge clk); 
	    @ (posedge clk); 
	    @ (posedge clk); 
            for (int i=1; i<1024;i++) begin
		valid = 0;
                x=0;
		@(posedge clk);
		@(posedge clk);
		valid = 1;
                x=i; 
		@(posedge clk); 
            end
        end

    end

    initial begin 
        clk = 0;
        forever begin
            clk = ~clk; 
            #10;
        end 
    end

endmodule 
    