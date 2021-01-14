/**********************************************************
19 October 2020
Description: bin averaging wrapper 
***********************************************************/

`timescale 1ns/1ns 
//`default_nettype none

module N_bin_collection #(
            parameter N = 16,
            //parameter N_AVGS = 7, // -- Total Averages = 2^N_AVGS
            //parameter SUM_WIDTH = 128,
            parameter BINS = 4
        )
        (
            input wire clk, areset_n,
            input wire fft_valid,
            input wire [N-1:0] in_data,
            output logic [BINS-1:0] [N-1:0] out_data,
            output logic output_valid
        );
        
    logic [31:0] bin_num, bin_num_d1;
    logic [BINS-1:0] [N-1:0] collect_data;
    logic valid_d1, valid_d2, first_valid, valid_d3, valid_d4;
    logic [N-1:0] in_data_d1, in_data_d2, in_data_d3, in_data_d4;
    logic [31:0] counter; 
    logic [15:0] valid_counter;
        
        
    /******************* state definitions *************************/
    typedef enum        logic[2:0]
                        {IDLE = 3'b001,
                        COLLECT = 3'b010,
                        SEND = 3'b111
                        } state_type;
    state_type state, next_state;
    /****************************************************************/
   
	//----------------------first valid-------------------------------
   always_ff @ (posedge clk or negedge areset_n)
        if (~areset_n)
            valid_counter <= 16'd0;
        else if (fft_valid == 1)
            valid_counter <= valid_counter +1;
            
    always_ff @ (posedge clk or negedge areset_n)
        if (~areset_n)
            first_valid <= 1'b0;
        else if (valid_counter == 1)
            first_valid <= valid_d1;
 
    //***************************************************************/
    //                  STATE MACHINE
    //***************************************************************/
    always @ (posedge clk or negedge areset_n) 
        if (~areset_n) 
            state <= IDLE;
        else 
            state <= next_state;

    always_ff @ (posedge clk or negedge areset_n)
        if (~areset_n)
            bin_num <= 1'd0;
        else if(fft_valid ==1)
            bin_num <= 'd0;
        else
            bin_num <= bin_num + 1;
            
    always_comb begin
        case (state)
            IDLE: begin
                if (valid_d2 == 1) 
                    next_state = COLLECT;
                else    
                    next_state = IDLE;
            end
            COLLECT: begin
                if (counter < (BINS-2)) begin
                    //$display("bins: ", BINS-1);
                    next_state = COLLECT;
                end
                else if (counter > (BINS-1))//((bin_num+1) == (BINS)) 
                    next_state = SEND;

            end
            SEND: begin
                if (valid_d2 == 1)
                    next_state = COLLECT;
                else
                    next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
     end
    
    //***************************************************************
    //      VALID DELAY
    //***************************************************************
    always_ff @ (posedge clk or negedge areset_n)
        if (~areset_n) begin
            bin_num_d1 <= 'd0;
            valid_d1 <= 1'b0;
        end
        else begin
            bin_num_d1 <= bin_num;
            valid_d1 <= fft_valid;
        end
    
    always_ff @ (posedge clk or negedge areset_n)
        if (~areset_n) begin
            valid_d2 <= 1'd0;
        end
        else 
            valid_d2 <= valid_d1;

    
    always_ff @ (posedge clk or negedge areset_n)
        if (~areset_n) begin
            valid_d3 <= 'd0;
        end
        else 
            valid_d3 <= valid_d2;


        
    //***************************************************************/
    //                  DATA HANDLING
    //***************************************************************/
            
    always_ff @ (posedge clk or negedge areset_n)
        if (~areset_n) begin
            out_data <= 'd0;
            output_valid <=1'b0;
            counter <= 'd0;
        end
        else begin  
            case(next_state)
                IDLE: begin
                    out_data <= 'd0;
                    output_valid <= 1'b0;
                    counter <= 'd0;
                end
                COLLECT: begin
                    //out_data <= 'd0;
                    collect_data[bin_num_d1] <= in_data_d2;
                    counter <= counter + 1;
                    output_valid <= 1'b0;

                end
                SEND: begin
                    //collect_data[bin_num_d1] <= in_data_d2;
                    out_data <= collect_data;
                    counter <= 'd0;
                    output_valid <= 1'b1;
                end
                default: begin
                    out_data <= 'd0;
                    output_valid <=1'b0;
                    counter <= 'd0;
                end
            endcase
        end //end: else
        
        
    //**********************************************************
    //              DATA DELAY
    //**********************************************************
    always_ff @ (posedge clk or negedge areset_n)
        if (~areset_n) begin
            in_data_d1 <= 'd0;
        end
        else 
            in_data_d1 <= in_data;

    always_ff @ (posedge clk or negedge areset_n)
        if (~areset_n) begin
            in_data_d2 <= 'd0;
        end
        else 
            in_data_d2 <= in_data_d1;

    always_ff @ (posedge clk or negedge areset_n)
        if (~areset_n) begin
            in_data_d3 <= 'd0;
        end
        else 
            in_data_d3 <= in_data_d2;


endmodule 