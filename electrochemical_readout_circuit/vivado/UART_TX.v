//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 2023/07/04 15:14:00
//// Design Name: 
//// Module Name: UART_TX
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


//module UART_TX(
//    input               clk,
//    input   [7:0]       tx_data,
//    input               rst,
//    input               enable,
//    input   [4 :0]      read_cnt,
//    input   [9: 0]      read_cnt_sub,
//    output  reg         tx_out
    
//    );
    
//    parameter       S_IDLE  = 3'd0;
//    parameter       S_START1= 3'd1;
//    parameter       S_TX1   = 3'd2;
//    parameter       S_STOP1 = 3'd3;
    
//    reg [2:0]       tx_state;
//    reg [7:0]       r_tx_data; 
    
//    always @ ( posedge clk or posedge rst ) begin
//        if (rst) begin
//            tx_state                <= S_IDLE;
//            tx_out                  <= 1'd1;
//            r_tx_data               <= 8'd0;
//        end else begin
//            if(read_cnt_sub==49) begin
//                case(tx_state)
//                    S_IDLE      :begin
//                        tx_state                <= (enable) ? S_START1 : tx_state ;
//                        tx_out                  <= (enable) ? 0        : tx_out;
//                    end
//                    S_START1    :begin
//                        tx_state                <= S_TX1;
//                        tx_out                  <= tx_data[0];                           
//                    end
//                    S_TX1       :begin
//                        tx_state                <= (read_cnt == 9 ) ? S_STOP1 : tx_state;
//                        tx_out                  <= (read_cnt == 9 ) ? 1       :tx_data[read_cnt-1];
//                    end
//                    S_STOP1     : begin
//                        tx_state                <= (read_cnt==11) ? S_IDLE : tx_state;
//                        tx_out                  <= tx_out;                       
//                    end
//                endcase
//            end else begin
//                tx_state            <= tx_state;
//                tx_out              <= tx_out;
//            end
//        end
//    end
    
    
    
//endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/04 15:14:00
// Design Name: 
// Module Name: UART_TX
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


module UART_TX(
    input               clk,
    input   [15:0]      tx_data,
    input               rst,
    input               enable,
    input   [4 :0]      read_cnt,
    input   [9: 0]      read_cnt_sub,
    output  reg         tx_out
    // output
    
    );
    
    parameter       S_IDLE  = 3'd0;
    parameter       S_START1= 3'd1;
    parameter       S_TX1   = 3'd2;
    parameter       S_STOP1 = 3'd3;
    parameter       S_START2= 3'd4;
    parameter       S_TX2   = 3'd5;
    parameter       S_STOP2 = 3'd6;
    
    reg [2:0]       tx_state;
    reg [7:0]       r_tx_data; 
    
    always @ ( posedge clk or posedge rst ) begin
        if (rst) begin
            tx_state                <= S_IDLE;
            tx_out                  <= 1'd1;
            r_tx_data               <= 8'd0;
        end else begin
            if(read_cnt_sub==49) begin
                case(tx_state)
                    S_IDLE      :begin
                        tx_state                <= (enable) ? S_START1 : tx_state ;
                        tx_out                  <= (enable) ? 0        : tx_out;
                    end
                    S_START1    :begin
                        tx_state                <= S_TX1;
                        tx_out                  <= tx_data[0];                           
                    end
                    S_TX1       :begin
                        tx_out                  <= (read_cnt == 9 ) ? 1       :tx_data[read_cnt-1];
                        tx_state                <= (read_cnt == 9 ) ? S_STOP1 : tx_state;
                    end
                    S_STOP1     : begin
                        tx_state                <= (read_cnt==11) ? S_START2 : tx_state;
                        tx_out                  <= (read_cnt==11) ? 0        : tx_out;                       
                    end
                    S_START2     : begin
                        tx_state                <= S_TX2;
                        tx_out                  <= tx_data[8];                         
                    end
                    S_TX2       :begin
                        tx_out                  <= (read_cnt == 20) ? 1        : tx_data[read_cnt-4];
                        tx_state                <= (read_cnt == 20) ? S_STOP2  : tx_state;
                    end
                    S_STOP2      :begin
                        tx_out                  <= (read_cnt == 21 ) ? 1       :tx_out;
                        tx_state                <= (read_cnt == 21 ) ? S_IDLE : tx_state;                       
                    end
                endcase
            end else begin
                tx_state            <= tx_state;
                tx_out              <= tx_out;
            end
        end
    end
    
    
    
endmodule
