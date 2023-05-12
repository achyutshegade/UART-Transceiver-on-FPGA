

module UART_controller(
    input clk,
    input reset,
    input tx_enable,
    input [7:0] data_in,
    output [7:0] data_out,
    input sl1,sl2,
    input rx1,
    output tx1,
    input rx2,
    output tx2,
    input rx3,
    output tx3
    );
    
    wire tx;
    reg rx;
    wire button_pressed;
    
    assign tx1 = (!sl1 && !sl2) ? tx : 0;
    assign tx2 = (!sl1 && sl2) ? tx : 0;
    assign tx3 = (sl1 && !sl2) ? tx : 0;
    
    always @(negedge clk)
    begin
        case({sl1,sl2})
        0 : rx = rx1;
        1 : rx = rx2;
        2 : rx = rx3;
        4 : rx = 0;
        endcase
    end
    
      
    
    button_debounce tx_button_controller(
                                         .clk(clk),
                                         .reset(reset),
                                         .button_in(tx_enable),
                                         .button_out(button_pressed)   
                                         );
    UART UART_transceiver(
                          .clk(clk),
                          .reset(reset),
                          .tx_start(button_pressed),
                          .data_in(data_in),
                          .data_out(data_out),
                          .rx(rx),
                          .tx(tx)
                          );
    
endmodule