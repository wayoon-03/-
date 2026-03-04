`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/14 18:50:53
// Design Name: 
// Module Name: PINGPONG
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


module PINGPONG(
    input               clk,
    input               rst,
    input               trig,
    input      [7:0]    PONG,
    
    output              tx_out
    );
    
reg enable;
reg [4 :0]      read_cnt;
reg [9 :0]      read_cnt_sub;
always @ ( posedge clk or posedge rst) begin
    if (rst) begin
        enable          <=0;
    end else begin
        if(trig || (read_cnt == 21 && read_cnt_sub==49))
            enable          <= !enable;
        else
            enable          <= enable;
    end
end

always @ ( posedge clk or posedge rst) begin
    if (rst) begin
        read_cnt_sub            <= 0;
        read_cnt                <= 0;
    end else begin
        if (enable) begin
            if( read_cnt_sub == 49 ) begin
                read_cnt_sub            <= 0;
                read_cnt                <= (read_cnt == 21) ? 0         : read_cnt + 1;
            end else begin
                read_cnt_sub            <= read_cnt_sub +1;
                read_cnt                <= read_cnt;
            end
        end else begin
            read_cnt_sub            <= 0;
            read_cnt                <= 0;
        end
    end
end   
wire    [15:0]  tx_data;
assign  tx_data= {6'd0,PONG};
UART_TX                 U_TX(
    .clk            (clk            ),
    .rst            (rst            ),
    .enable         (enable         ),
    .read_cnt       (read_cnt       ),
    .read_cnt_sub   (read_cnt_sub   ),
    .tx_data        (tx_data        ),
    
    .tx_out         (tx_out         )
);
    
    
endmodule
