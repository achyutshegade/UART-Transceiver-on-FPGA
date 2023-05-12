`timescale 1ns / 1ps


module UART_tx #(
    parameter CLK_DIV = 10416 //10416, 868
    ) (
    input clk,
    input reset,
    input [7:0] tx_data_in,
    input tx_start,
    output reg tx_data_out
    );

    
    
//    wire rst;
//    assign rst = ~reset;
    
    reg [$clog2(CLK_DIV)+2:0] counter = CLK_DIV-1 ;
    reg baud_rate=0;
    reg start_rst = 0;
    reg start_detected = 0;
    reg [7:0] stored_data=8'b00000000;
    reg [2:0] data_index = 0;
    reg data_index_rst = 1;
    
    //baud clk generator
    always @(posedge clk)
    begin
        if(reset) 
            begin
            counter <= (CLK_DIV -1);
            baud_rate <= 0;
            end
        else if(counter == 0) 
            begin
            counter <= (CLK_DIV -1);
            baud_rate <= 1;
            end
        else 
        begin
            counter <= counter -1;
            baud_rate <= 0;
            end
    end
    
    //tx_start detector
    always @(posedge clk)
    begin
        if(reset || start_rst)
            begin
            start_detected <=0;
            end
        else if(tx_start==1 && start_detected==0)
            begin
            start_detected <=1;
            stored_data <= tx_data_in;
            end
    end
    
          
    //data index counter
    always @(posedge clk)
    begin
        if(reset || data_index_rst)
            data_index <=0;
        else if(baud_rate==1)
            data_index <= data_index + 1;
    end
      
    localparam IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
    reg [1:0] present_state=0;
//    reg [1:0] next_state=0;

    always @(posedge clk)
    begin
    if(reset)
        begin
        present_state <= 2'b00;
        data_index_rst <= 1;
        start_rst <= 1;
        tx_data_out <=1;
        end
    else
        if(baud_rate)
        begin
        case(present_state)
        IDLE: begin
                data_index_rst <=1;
                start_rst <= 0;
                tx_data_out <=1;
                if(start_detected)
                begin
                present_state <= 2'b01;
                end
              end
        START: begin
                 data_index_rst <=0;
                 tx_data_out <=0;
                 present_state <= 2'b10;
               end
        DATA: begin
                tx_data_out <= stored_data[data_index];
                if(data_index == 7)
                begin
                data_index_rst <=1;
                present_state <= 2'b11;
                end
              end
        STOP: begin
                tx_data_out <=1;
                start_rst <= 1;
                present_state <= 2'b00;
              end  
        default:  present_state <= 2'b00;
        endcase
        end
    end
    
endmodule