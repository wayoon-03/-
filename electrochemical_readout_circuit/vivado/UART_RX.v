`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/13 21:38:16
// Design Name: 
// Module Name: UART_RX
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


module UART_RX(
    input               clk,
    input               rst,
    input               serial_in,
    output  reg  [7:0]  rx_out, // can be replaced by "rx_reg"
    output  reg         rx_out_pulse
    );
    
    parameter         S_IDLE  = 2'd0;
	parameter	      S_START = 2'd1;
	parameter	      S_RX    = 2'd2;
	parameter	      S_STOP  = 2'd3;

	reg [1:0] rx_state;
	reg [9:0] rx_cnt;
	reg [2:0] rx_state_cnt;
	reg [7:0] rx_out_reg;

	//cnt 69
always @ (posedge clk or posedge rst ) begin
    if (rst) begin
        rx_state           <= S_IDLE;
        rx_out             <= 7'd0;
        rx_out_reg         <= 7'd0;
        rx_cnt             <= 0;  
        rx_state_cnt       <= 0;
        rx_out_pulse       <= 0;
    end else begin
        case( rx_state )
        	S_IDLE     :begin
        	   rx_out          <= 7'd0;
        	   rx_out_reg      <= 7'd0;
        	   rx_cnt          <= 0;
        	   rx_out_pulse    <= 0;
        	   if ( serial_in == 0 )
        	       rx_state <= S_START;
        	   else
        	       rx_state <= rx_state;
            end
            S_START     :begin
        	   rx_out_reg        <= 1'd0;
        	   rx_out_pulse    <= 0;
        	   if ( rx_cnt == 10'd49 ) begin
        	       rx_state            <= S_RX;
        	       rx_cnt              <= 0;
        	   end else begin
        	       rx_state            <= rx_state;
        	       rx_cnt              <= rx_cnt + 10'd1;
        	   end
            end
            S_RX        :begin
        	   rx_state                <= ( rx_state_cnt ==7 ) ?  S_STOP    : rx_state;
        	   rx_out_pulse            <=  0;
        	   if ( rx_cnt == 10'd49 ) begin
        	       rx_state_cnt        <= rx_state_cnt + 3'd1;
        	       rx_cnt              <= 0;
        	       rx_out_reg          <= rx_out_reg;
        	   end else begin
        	       rx_state            <= rx_state;
        	       rx_cnt              <= rx_cnt + 10'd1;
        	       rx_out_reg[rx_state_cnt]    <= ( rx_cnt == 10'd24 ) ?  serial_in : rx_out_reg[rx_state_cnt];
        	   end
            end
            S_STOP     :begin
        	   if ( rx_cnt == 10'd49 ) begin
        	       rx_state            <= S_IDLE;
        	       rx_cnt              <= 0;
        	   end else begin
        	       rx_state            <= rx_state;
        	       rx_cnt              <= rx_cnt + 10'd1;
        	       rx_out              <= rx_out_reg;
        	       rx_out_pulse        <= (rx_cnt==10'd24);
        	   end
            end
        endcase
    end
end     
    
    
    
endmodule
