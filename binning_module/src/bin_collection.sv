/**********************************************************
19 October 2020
Description: bin averaging wrapper 
***********************************************************/

`timescale 1ns/1ns 
//`default_nettype none

module N_bin_collection #(
            parameter N = 16,
            parameter N_AVGS = 7, // -- Total Averages = 2^N_AVGS
            parameter SUM_WIDTH = 128,
            parameter BINS = 4
        )
        (
            input wire clk, areset_n,
            input wire fft_valid,
            input logic [N-1:0] in_data,
            output logic [BINS-1:0] [N-1:0] out_data
        );
        
    logic [31:0] bin_num;
    logic [BINS-1:0] [N-1:0] collect_data;
    logic test;
    logic [N-1:0] in_data_d1;
        
        
    /******************* state definitions *************************/
    typedef enum        logic[2:0]
                        {IDLE = 3'b001,
                        COLLECT = 3'b010,
                        SEND = 3'b100
                        } state_type;
    state_type state, next_state;
    /****************************************************************/
    
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
            bin_num <= 32'd0;
        else if (fft_valid ==1) begin
            bin_num <= 32'd0;
            test <= fft_valid;
        end
        else if (bin_num == BINS)
            bin_num <=32'd0;
        else begin
            bin_num <= bin_num + 1;
            test <= 1'b0;
         end
            
    always_comb begin
        case (state)
            IDLE: begin
                if (test == 1)
                    next_state = COLLECT;
                else    
                    next_state = IDLE;
            end
            COLLECT: begin
                if (bin_num < (BINS-1)) begin
                    $display("bins: ", BINS-1);
                    next_state = COLLECT;
                end
                else if (bin_num > (BINS-1)) 
                    next_state = SEND;
            end
            SEND: begin
                next_state = IDLE;
            end 
            default: begin
                next_state = IDLE;
            end
        endcase
     end
        
    //***************************************************************/
    //                  DATA HANDLING
    //***************************************************************/
    always_ff @ (posedge clk or negedge areset_n)
        if (~areset_n) begin
            in_data_d1 <= 'd0;
        end
        else 
            in_data_d1 <= in_data;
            
    always_ff @ (posedge clk or negedge areset_n)
        if (~areset_n) begin
            out_data <= 'd0;
            collect_data <= 'd0;
        end
        else begin  
            case(next_state)
                IDLE: begin
                    out_data <= 'd0;
                    collect_data <= 'd0;
                end
                COLLECT: begin
                    collect_data[bin_num] <= in_data_d1;
                end
                SEND: begin
                    out_data <= collect_data;
                end
                default: begin
                end
            endcase
        end //end: else
endmodule 