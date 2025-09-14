`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/10 10:20:42
// Design Name: 
// Module Name: MAIN
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


module MAIN(
    input               sys_clk,
    input               rst,
    input               rst2,
    input               serial_in,
    input               adc_out,
    
    output              dac_in,
    output              sync,
    output              dac_clk,
    output              adc_clk,
    output              cs,
    output              serial_out
    );

assign serial_out =  tx_PONG & tx_out ;
assign adc_clk    =  dac_clk ;

design_2_wrapper    U_CLK(
    .clk_in1_0      (sys_clk),
    .clk_out1_0     (clk),
    .reset_0        (rst2)
);

wire                 adc_clk;
wire          [2:0]  state;
wire          [15:0] ramp_out;
wire          [5:0]  delay_cnt;  
wire         [15:0]  set_min;
wire         [15:0]  set_max;
wire         [15:0]  dc_input;
wire         [15:0]  read_length;
wire         [15:0]  ram_addr;
wire         [11:0]  adc_data;


reg           [1:0]  r_rst;
assign  trig = r_rst[1] && ~r_rst[0];
always @ (posedge clk)
    r_rst <= {r_rst[0], rst};
    

    
RAMP            U_RAMP(
    .clk        (clk),
    .rst        (rst),
    .trig       (trig),
    .ramp_enable(ramp_enable),
    .set_min    (set_min),
    .set_max    (set_max),
    .read_length(read_length),
    .state      (state),
    .ramp_out   (ramp_out),
    .delay_cnt  (delay_cnt),
    .read_cnt   (ram_addr),
    .dc_enable  (dc_enable),
    .dc_input   (dc_input)
    
);

SER             U_SER(
    .clk        (clk),
    .rst        (rst),
    .ramp_out   (ramp_out),
    .delay_cnt  (delay_cnt),
    .dac_in     (dac_in),
    .sync       (sync),
    .dac_clk    (dac_clk)     
);


DES             U_DES(
    .clk        (clk),
    .rst        (rst),
    .delay_cnt  (delay_cnt),
    .adc_out    (adc_out),
    .adc_data   (adc_data),
    .cs         (cs)
);

wire    [ 7:0]  PONG;
RX_CTRL                 U_RX_CTRL(
    .clk                (clk                ),
    .rst                (rst                ),
    .serial_in          (serial_in          ),
    .PONG               (PONG               ), // --> PINGPONG
    .PING_PONG_trig     (PING_PONG_trig     ), // --> PINGPONG
    .ramp_enable        (ramp_enable        ),
    .set_min            (set_min            ),
    .set_max            (set_max            ),
    .read_length        (read_length        ),
    .dc_enable          (dc_enable),
    .dc_input           (dc_input)
);


wire [11:0]     adc_data_unsigned;
assign adc_data_unsigned = adc_data + 11'd2047;


RAM_CTRL                U_RAM_CTRL(
    .clk                (clk                ),
    .rst                (rst                ),
    .read_data          (adc_data_unsigned  ),
    .ram_addr           (ram_addr           ),
    .read_length        (read_length        ),
    .tx_out             (tx_out             )
);

PINGPONG                U_PINGPONG(
    .clk                (clk                ),
    .rst                (rst                ),    
    .trig               (PING_PONG_trig     ),
    .PONG               (PONG               ),
    .tx_out             (tx_PONG            )                  
);




endmodule
