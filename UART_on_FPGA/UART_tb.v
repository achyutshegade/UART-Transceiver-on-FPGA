`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2023 15:48:44
// Design Name: 
// Module Name: USB_controller_tb
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

module USB_controller_tb();
reg clk=0;
reg reset;
reg tx_enable;
reg [7:0] data_in;
wire [7:0] data_out;
reg rx;
wire tx;



UART_controller DUT(clk,reset,tx_enable,data_in,data_out,tx,tx);


always
#10 clk=~clk;

initial
begin
reset=0;
#15 reset=1;
#15 reset=0;
data_in = 8'b10010001;
#1500 tx_enable=1;
#25 tx_enable=0;
#25 tx_enable=1;
#10000000 data_in = 8'b11111111;
#1500 tx_enable=1;
#25 tx_enable=0;
#25 tx_enable=1;
#10000000 data_in = 8'b11110100;
#1500 tx_enable=1;
#25 tx_enable=0;
#25 tx_enable=1;
end
//initial 
//begin
//rst=0;
////# 15 rst=0;
//data=8'b11010111;
//#17000 tx_start=1;
//#1000 tx_start=0;
//#200000 tx_start=1;
//data=8'b10010011;
//#10000 tx_start=0;
//end

endmodule