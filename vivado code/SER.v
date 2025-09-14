`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/10 19:37:34
// Design Name: 
// Module Name: SER
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


module SER(
    input               clk,
    input               rst,
    input        [15:0] ramp_out,
    input        [5:0]  delay_cnt,
    output  reg         dac_in,
    output  reg         sync,
    output  wire        dac_clk
    );

assign dac_clk =clk;
  
always @ (posedge clk or posedge rst) begin
    if(rst) begin
        dac_in   <= 1'b0;
        sync     <= 1'b1;
    end
    else begin 
        case(delay_cnt) 
            6'd0  : begin
                dac_in <= 1'b0;         //
                sync   <= 1'b0;
            end
            6'd1  : begin 
                dac_in <= 1'b0;         //
                sync   <= 1'b0;
            end
            6'd2  : begin
                dac_in <= ramp_out[15];   // 15 MSB
                sync   <= 1'b0;
            end
            6'd3  : begin
                dac_in <= ramp_out[14];   // 14 
                sync   <= 1'b0;
            end
            6'd4  : begin
                dac_in <= ramp_out[13];   // 13 
                sync   <= 1'b0;
            end
            6'd5  : begin
                dac_in <= ramp_out[12];   // 12 
                sync   <= 1'b0;
            end
            6'd6  : begin
                dac_in <= ramp_out[11];  //  11 
                sync   <= 1'b0;
            end
            6'd7  : begin
                dac_in <= ramp_out[10];  //  10 
                sync   <= 1'b0;
            end
            6'd8  : begin
                dac_in <= ramp_out[9];  //  9 
                sync   <= 1'b0;
            end
            6'd9  : begin
                dac_in <= ramp_out[8];  //  8 
                sync   <= 1'b0;
            end
            6'd10 : begin
                dac_in <= ramp_out[7];  //  7 
                sync   <= 1'b0;
            end
            6'd11 : begin
                dac_in <= ramp_out[6];  //  6 
                sync   <= 1'b0;
            end
            6'd12 : begin
                dac_in <= ramp_out[5];  //  5 
                sync   <= 1'b0;
            end
            6'd13 : begin
                dac_in <= ramp_out[4];  //  4 
                sync   <= 1'b0;
            end
            6'd14 : begin
                dac_in <= ramp_out[3];  //  3 
                sync   <= 1'b0;
            end
            6'd15 : begin
                dac_in <= ramp_out[2];  //  2 
                sync   <= 1'b0;
            end
            6'd16 : begin
                dac_in <= ramp_out[1];  //  1 
                sync   <= 1'b0;
            end
            6'd17 : begin
                dac_in <= ramp_out[0];  //  0 
                sync   <= 1'b0;
            end
            default : begin
                dac_in <= 0;
                sync   <= 1;
            end
        endcase
    end
    
end
    
    
      
    
endmodule
