`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2021 11:55:05 AM
// Design Name: 
// Module Name: ddc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ddc_tb();
    reg clk;
    reg a_reset;
    reg avalid, bvalid;
    reg [31:0] x0_real_res1, x0_im_res1, x0_real_res2, x0_im_res2;
    reg [31:0] x1_real_res1, x1_im_res1, x1_real_res2, x1_im_res2;
    reg [31:0] x2_real_res1, x2_im_res1, x2_real_res2, x2_im_res2;
    reg [31:0] x3_real_res1, x3_im_res1, x3_real_res2, x3_im_res2;
    integer i;
    
    //unit under test instantiation
    ddc_top uut(
        .clk(clk),
        .a_reset(a_reset),
        .x0_real_res1(x0_real_res1),
        .x0_real_res2(x0_real_res2),
        .x0_im_res1(x0_im_res1), 
        .x0_im_res2(x0_im_res2),
        .x1_real_res1(x1_real_res1),
        .x1_im_res1(x1_im_res1),
        .x1_real_res2(x1_real_res2),
        .x1_im_res2(x1_im_res2),
        .x2_real_res1(x2_real_res1),
        .x2_im_res1(x2_im_res1), 
        .x2_real_res2(x2_real_res2), 
        .x2_im_res2(x2_im_res2),
        .x3_real_res1(x3_real_res1), 
        .x3_im_res1(x3_im_res1), 
        .x3_real_res2(x3_real_res2), 
        .x3_im_res2(x3_im_res2),
        .s_axis_b_tvalid(bvalid),
        .s_axis_a_tvalid(avalid)
    );
    
    initial begin
        clk = 0; #40;
        forever begin
            clk = ~clk; #10; //50MHz 
        end    
    end
    
    initial begin
        //initialize signals
        a_reset = 0;
        avalid = 1'b0;
        bvalid = 1'b0;
        
        x0_real_res1 = 32'd0; 
        x0_im_res1 = 32'd0;
        x0_real_res2 = 32'd0;
        x0_im_res2 = 32'd0;
        x1_real_res1 = 32'd0;
        x1_im_res1 = 32'd0;
        x1_real_res2 = 32'd0;
        x1_im_res2 = 32'd0;
        
        x2_real_res1 = 32'd0;
        x2_im_res1 = 32'd0;
        x2_real_res2 = 32'd0;
        x2_im_res2 = 32'd0;
        x3_real_res1 = 32'd0;
        x3_im_res1 = 32'd0;
        x3_real_res2 = 32'd0;
        x3_im_res2 = 32'd0;
        #40; //pause for reset
        
        
        a_reset = 1;
        //set signals in UUT high for complex multiply 
        avalid = 1'b1;
        bvalid = 1'b1;
        $display("done with reset");
        
        //for loop represents values for cmult that would come from PFB
        for(i = 1; i <= 256; i=i+1) begin
            x0_real_res1 = i; //value for resonator 1, real value
            x0_im_res1 = i;
            x0_real_res2 = i;
            x0_im_res2 = i;
            x1_real_res1 = i;
            x1_im_res1 = i;
            x1_real_res2 = i;
            x1_im_res2 = i;
            
            x2_real_res1 = i;
            x2_im_res1 = i;
            x2_real_res2 = i;
            x2_im_res2 = i;
            x3_real_res1 = i;
            x3_im_res1 = i;
            x3_real_res2 = i;
            x3_im_res2 = i;
            @ (posedge clk);
        end
        
        for(i = 1; i <= 256; i=i+1) begin
            x0_real_res1 = i;
            x0_im_res1 = i;
            x0_real_res2 = i;
            x0_im_res2 = i;
            x1_real_res1 = i;
            x1_im_res1 = i;
            x1_real_res2 = i;
            x1_im_res2 = i;
            
            x2_real_res1 = i;
            x2_im_res1 = i;
            x2_real_res2 = i;
            x2_im_res2 = i;
            x3_real_res1 = i;
            x3_im_res1 = i;
            x3_real_res2 = i;
            x3_im_res2 = i;
            @ (posedge clk);
        end

        #100000;

    end
endmodule
