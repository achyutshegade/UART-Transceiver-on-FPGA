`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2023 19:32:30
// Design Name: 
// Module Name: button_debounce
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


module button_debounce #(
    parameter COUNTER_SIZE = 10000
    )(
    input clk,
    input reset,
    input button_in,
    output reg button_out
    );
    
    reg ff1 = 0;
    reg ff2 = 0;
    reg ff3 = 0;
    reg ff4 = 0;
    wire count_start = 0;
    
    always @(posedge clk)
    if(reset==1)begin
        ff1 <= 0;
        ff2 <= 0;
    end
    else begin
        ff1 <= button_in;
        ff2 <= ff1;
    end
    
    assign count_start = ff1 ^ ff2;
    
    reg [0:COUNTER_SIZE] count =0;
    
    always @(posedge clk)begin
        if(reset == 1)begin
            count <= 0;
            ff3 <= 0;
            end
        else if(count_start ==1) count <= 0;
        else if (count < COUNTER_SIZE) count <= count + 1;
        else ff3 <= ff2;
        
    end
    
    always @(posedge clk)begin
        if(reset ==1)
            ff4 <= 0;
        else   ff4 <= ff3;
    end
    
    always @(posedge clk)begin
        if(ff3 ==1) button_out <= ff3^ff4;
        else button_out <= 0;
        end
    
    
    
endmodule
