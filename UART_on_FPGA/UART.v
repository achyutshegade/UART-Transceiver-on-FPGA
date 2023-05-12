`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2023 20:13:53
// Design Name: 
// Module Name: UART
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


module UART(
    input clk,
    input reset,
    input tx_start,
    input [7:0] data_in,
    output wire [7:0] data_out,
    input rx,
    output tx
    );
    
//    wire rst;


    
    UART_tx transmitter(
                        .clk(clk),
                        .reset(reset),
                        .tx_data_in(data_in),
                        .tx_start(tx_start),
                        .tx_data_out(tx)
                        );
    UART_rx receiver(
                    .clk(clk),
                    .reset(reset),
                    .rx_data_in(rx),
                    .rx_data_out(data_out));
    
    
endmodule
