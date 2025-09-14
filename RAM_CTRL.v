`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/07 17:48:48
// Design Name: 
// Module Name: REG_CTRL
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


module RAM_CTRL(
    input                   clk,
    input                   rst,
    input           [11:0]  read_data,
    input           [15:0]  ram_addr,
    input           [15:0]  read_length,
    
    
    output                  tx_out
    );


wire            write_enable;
reg             write_enable_r;
wire            read_start; 
reg             read_enable;
reg [4 :0]      read_cnt;
reg [9 :0]      read_cnt_sub;
reg      [15:0] addrb;
wire     [15:0] ram_out;
assign          write_enable = |ram_addr;


always @ (posedge clk or posedge rst) begin
    if( rst) begin
        write_enable_r <= 0 ;
    end
    else begin
        write_enable_r <=write_enable;
    end
end    

assign          read_start = !write_enable  && write_enable_r;

always @ (posedge clk or posedge rst) begin
    if( rst) begin
        write_enable_r <= 0 ;
    end
    else begin
        write_enable_r <=write_enable;
    end
end    



always @ ( posedge clk or posedge rst) begin
    if (rst) begin
        read_enable             <=0;
    end
    else begin
        if (read_start) begin
            read_enable             <= 1;
        end 
        else if (addrb == read_length + 1)
            read_enable             <= 0;
        else begin
            read_enable             <= read_enable;
        end
    end
end      

always @ ( posedge clk or posedge rst) begin
    if (rst) begin
        read_cnt_sub            <= 0;
        read_cnt                <= 0;
        addrb                   <= 16'd1;
    end else begin
        if (read_enable) begin
            if( read_cnt_sub == 49 ) begin
                read_cnt_sub            <= 0;
                read_cnt                <= (read_cnt == 21) ? 0         : read_cnt + 1;
                addrb                   <= (read_enable)    ? (read_cnt == 21) ? addrb + 1   : addrb    : addrb;
            end else begin
                read_cnt_sub            <= read_cnt_sub +1;
                read_cnt                <= read_cnt;
                addrb                   <= addrb;
            end
        end else begin
            read_cnt_sub            <= 0;
            read_cnt                <= 0;
            addrb                   <= 1;
        end
    end
end      

    
design_1_wrapper            U_reg(
    .addra_0        (ram_addr           ),
    .clka_0         (clk                ),
    .dina_0         ({4'd0, read_data}  ),
    .ena_0          (write_enable   ),
    .wea_0          (write_enable   ),
    
    .addrb_0        (addrb          ),
    .clkb_0         (clk            ),
    .doutb_0        (ram_out        ),
    .enb_0          (read_enable    )
);

  
UART_TX                 U_TX(
    .clk            (clk            ),
    .rst            (rst            ),
    .enable         (read_enable    ),
    .read_cnt       (read_cnt       ),
    .read_cnt_sub   (read_cnt_sub   ),
    .tx_data        (ram_out        ),
    
    .tx_out         (tx_out         )
);



endmodule
