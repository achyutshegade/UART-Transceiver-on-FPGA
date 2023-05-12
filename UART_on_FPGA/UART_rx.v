`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2023 18:12:05
// Design Name: 
// Module Name: UART_rx
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


module UART_rx #(
    parameter BAUD_X16_CLK_TICKS = 651 //651,54 -- clk/baud_rate (100 000 000 / 115 200 = 868.0555)
    )(
    input clk,
    input reset,
    input rx_data_in,
    output reg [7:0] rx_data_out
    );
    
    reg baud_rate_x16 = 0;
    reg [7:0] rx_stored_data=0;
    
    reg [1:0] present_state = 0;
//    reg [1:0] next_state = 0;
    
    localparam IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
    
    reg [0:$clog2(BAUD_X16_CLK_TICKS)-1] baud_x16_count = (BAUD_X16_CLK_TICKS-1);
    
    always @(posedge clk)
    begin
       if(reset)
        begin
            baud_rate_x16 <= 0;
            baud_x16_count <= (BAUD_X16_CLK_TICKS - 1);
        end
        else
            if(baud_x16_count == 0)begin
                baud_rate_x16 <= 1;
                baud_x16_count <= (BAUD_X16_CLK_TICKS - 1);
            end 
            else begin
                baud_rate_x16 <= 0;
                baud_x16_count <= (baud_x16_count - 1);
            end
    end
    
    reg [0:15] bit_duration_count = 0;
    reg [0:7] bit_count = 0;
    
    always @(posedge clk)
    begin
        if(reset)begin
            present_state <= IDLE;
            rx_stored_data <= 0;
            rx_data_out <= 0;
            bit_duration_count <= 0; 
            bit_count <= 0; 
        end
        else
            if(baud_rate_x16 == 1)
                case(present_state)
                    IDLE: begin
                            rx_stored_data <= 0;
                            bit_duration_count = 0;
                            bit_count <= 0;
                            if(rx_data_in == 0)
                                present_state <= START;
                            end
                            
                    START: begin
                            if(rx_data_in == 0)
                                if(bit_duration_count == 7)begin
                                present_state <= DATA;
                                bit_duration_count <= 0;
                                end
                                else
                                    bit_duration_count <= bit_duration_count +1; 
                            else 
                            present_state <= IDLE;
                            end
                    DATA: begin
                            if(bit_duration_count ==15)begin
                                rx_stored_data[bit_count] <= rx_data_in;
                                bit_duration_count <= 0;   
                                if(bit_count ==7)begin    
                                    present_state <= STOP;
                                    bit_duration_count <= 0;  
                                end
                                else
                                    bit_count <= bit_count + 1; 
                                end
                            else
                                bit_duration_count <= bit_duration_count +1; 
                            end
                            
                    STOP: begin
                            if(bit_duration_count ==15)begin
                                rx_data_out <= rx_stored_data;
                                present_state <= IDLE;
                            end
                            else
                                bit_duration_count <= bit_duration_count +1;
                            end
                            
                    default: present_state <= IDLE;
                endcase
    
    end
    
    
endmodule
