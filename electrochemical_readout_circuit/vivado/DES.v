`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/23 14:15:10
// Design Name: 
// Module Name: DES
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


module DES(
    input               clk,
    input               rst,
    input        [5:0]  delay_cnt, 
    input               adc_out,
    output  reg [11:0]  adc_data,
    output  reg         cs
    );
    
    
always @ (negedge clk or posedge rst) begin
    if(rst) begin
        cs          <= 1'b1;
    end
    else begin 
        case(delay_cnt) 
            6'd0  : begin
                cs          <= 1'b0;
            end
            6'd1  : begin 
                cs          <= 1'b0;
            end
            6'd2  : begin
                cs          <= 1'b0;
            end
            6'd3  : begin
                cs     <= 1'b0;
            end
            6'd4  : begin
                cs     <= 1'b0;
            end
            6'd5  : begin
                cs     <= 1'b0;
            end
            6'd6  : begin
                cs     <= 1'b0;
            end
            6'd7  : begin
                cs     <= 1'b0;
            end
            6'd8  : begin
                cs     <= 1'b0;
            end
            6'd9  : begin
                cs     <= 1'b0;
            end
            6'd10 : begin
                cs     <= 1'b0;
            end
            6'd11 : begin
                cs     <= 1'b0;
            end
            6'd12 : begin
                cs     <= 1'b0;
            end
            6'd13 : begin
                cs     <= 1'b0;
            end
            6'd14 : begin
                cs     <= 1'b0;
            end
            default : begin
                cs       <= 1'b1;
            end
        endcase
    end
    
end

always @ (posedge clk or posedge rst) begin
    if(rst) begin
        adc_data    <= 12'b0;
    end
    else begin 
        case(delay_cnt) 
            6'd2  : begin
                adc_data[11]<= adc_out;   // 11 MSB
            end
            6'd3  : begin
                adc_data[10]<= adc_out;   // 10
            end
            6'd4  : begin
                adc_data[9] <= adc_out;   // 9
            end
            6'd5  : begin
                adc_data[8] <= adc_out;   // 8
            end
            6'd6  : begin
                adc_data[7] <= adc_out;  //  7
            end
            6'd7  : begin
                adc_data[6] <= adc_out;  //  6
            end
            6'd8  : begin
                adc_data[5] <= adc_out;  //  5
            end
            6'd9  : begin
                adc_data[4] <= adc_out;  //  4
            end
            6'd10 : begin
                adc_data[3] <= adc_out;  //  3
            end
            6'd11 : begin
                adc_data[2] <= adc_out;  //  2
            end
            6'd12 : begin
                adc_data[1] <= adc_out;  //  1
            end
            6'd13 : begin
                adc_data[0] <= adc_out;  //  0 LSB
            end
            default : begin
                adc_data <= adc_data;
            end
        endcase
    end
end


//design_3_wrapper        U_ILA(
//   .clk_0       (clk),
//   .probe0_0    (cs),
//   .probe1_0    (adc_out ),
//   .probe2_0    (adc_data)
//);
endmodule
