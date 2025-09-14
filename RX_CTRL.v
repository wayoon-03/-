`timescale 1ns / 1ps

module RX_CTRL(
    input               clk,
    input               rst,
    input               serial_in,

    output  reg  [ 7:0] PONG,
    output  reg         PING_PONG_trig,
    output  reg         ramp_enable,
    output  reg         dc_enable,
    output  reg  [15:0] set_min,
    output  reg  [15:0] set_max,
    output  reg  [15:0] read_length,
    output  reg  [15:0] dc_input
//    output  reg  [3 :0]  state
);


    wire    [7 :0]      rx_out;
    reg     [3 :0]      state;
    reg     [1:0]       counter;
//    wire                rx_out_pulse;
//    reg     [15:0]      temp_dc_input;

    parameter          S_IDLE           = 4'd0;
    parameter          S_PINGPONG       = 4'd1;
    parameter          S_SET_MIN        = 4'd2;
    parameter          S_SET_MAX        = 4'd3;
    parameter          S_DC_INPUT       = 4'd4;
    parameter          S_RUN_RAMP       = 4'd5;
    parameter          S_RUN_DC         = 4'd6;
    parameter          S_READ_DATA_RAMP = 4'd7;
    parameter          S_READ_DATA_DC   = 4'd8;


    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            state                   <= S_IDLE;
            PONG                    <= 8'd0;
            counter                 <= 1'b0;
            PING_PONG_trig          <= 0;
            set_min                 <= 16'd0;
            set_max                 <= 16'd0;
            dc_input                <= 16'd0;
            ramp_enable             <= 0;
            read_length             <= 0;
            dc_enable               <= 0;
        end else begin
            case (state)
                S_IDLE      :begin
                    counter                 <= 1'b0;
                    PING_PONG_trig          <= 0;
                    set_min                 <= set_min;
                    set_max                 <= set_max;
                    PONG                    <= PONG;
                    ramp_enable             <= ramp_enable;
                    dc_enable               <= dc_enable;
                    dc_input                <= dc_input;
                    read_length             <= read_length;
                    if (rx_out == 1 && rx_out_pulse) begin
                        state                   <= S_PINGPONG;
                    end else if (rx_out == 2 && rx_out_pulse) begin
                        state                   <= S_SET_MIN;
                    end else if (rx_out == 3 && rx_out_pulse) begin
                        state                   <= S_SET_MAX;
                    end else if (rx_out == 4 && rx_out_pulse) begin
                        state                   <= S_DC_INPUT;
                    end else if (rx_out == 5 && rx_out_pulse) begin
                        state                   <= S_RUN_RAMP;
                    end else if (rx_out == 6 && rx_out_pulse) begin
                        state                   <= S_RUN_DC;
                    end else if (rx_out == 7 && rx_out_pulse) begin
                        state                   <= S_READ_DATA_RAMP;
                    end else if (rx_out == 8 && rx_out_pulse) begin
                        state                   <= S_READ_DATA_DC;
                    end else
                        state                   <= state;
                end



                S_PINGPONG  :begin
                    counter                 <= 1'b0;
                    ramp_enable             <= ramp_enable;
                    dc_enable               <= dc_enable;
                    read_length             <= read_length;
                    if (rx_out_pulse) begin
                        PONG[7:0]               <= rx_out;
                        state                   <= S_IDLE;
                        PING_PONG_trig          <= 1;
                    end else begin
                        PONG[7:0]               <= PONG[7:0];
                        state                   <= state;
                        PING_PONG_trig          <= 0;
                    end
                end

                S_SET_MIN     :begin
                    PING_PONG_trig          <= 0;
                    PONG                    <= 0;
                    ramp_enable             <= ramp_enable;
                    dc_enable               <= 0;
                    read_length             <= read_length;
                    if (rx_out_pulse) begin
                        counter                 <= counter + 1;
                        if (counter) begin
                            set_min[15:8]           <= rx_out;
                            state                   <= S_IDLE ;
                        end else begin
                            set_min[ 7:0]           <= rx_out;
                            state                   <= state;
                        end
                    end else begin
                        counter                 <= counter;
                    end
                end

                S_SET_MAX  : begin
                    PING_PONG_trig          <= 0;
                    PONG                    <= 0;
                    ramp_enable             <= ramp_enable;
                    dc_enable               <= 0;
                    read_length             <= read_length;
                    if (rx_out_pulse) begin
                        counter                 <= counter + 1;
                        if (counter) begin
                            set_max[15:8]           <= rx_out;
                            state                   <= S_IDLE ;
                        end else begin
                            set_max[ 7:0]           <= rx_out;
                            state                   <= state;
                        end
                    end else begin
                        counter                 <= counter;
                    end
                end

                S_DC_INPUT     :begin
                    PING_PONG_trig          <= 0;
                    PONG                    <= 0;
                    ramp_enable             <= 0;
                    dc_enable               <= dc_enable;
                    read_length             <= read_length;
                    if (rx_out_pulse) begin
                        counter             <= counter + 1;
                        if (counter) begin
                            dc_input[15:8] <= rx_out;
                            state          <= S_IDLE;
                        end else begin
                            dc_input[7:0]  <= rx_out;
                            state          <= state;
                        end
                    end else begin
                        counter            <= counter;
                    end
                end
                
                S_RUN_RAMP  : begin
                    counter                 <= 1'b0;
                    PING_PONG_trig          <= 0;
                    set_min                 <= set_min;
                    set_max                 <= set_max;
                    dc_input                <= 0;
                    PONG                    <= 0;
                    ramp_enable             <= 1;
                    dc_enable               <= 0;
                    state                   <= S_IDLE;
                    read_length             <= read_length;
                end

                S_RUN_DC  : begin
                    counter                 <= 1'b0;
                    PING_PONG_trig          <= 0;
                    set_min                 <= 0;
                    set_max                 <= 0;
                    dc_input                <= dc_input;
                    PONG                    <= 0;
                    ramp_enable             <= 0;
                    dc_enable               <= 1;
                    state                   <= S_IDLE;
                    read_length             <= read_length;
                end

                S_READ_DATA_RAMP     : begin
                    PING_PONG_trig          <= 0;
                    set_min                 <= set_min;
                    set_max                 <= set_max;
                    dc_input                <= 0;
                    PONG                    <= 0;
                    if (rx_out_pulse) begin
                        counter                 <= counter + 1;
                        if (counter) begin
                            read_length[15:8]       <= rx_out;
                            ramp_enable             <= 0;
                            state                   <= S_IDLE ;
                        end else begin
                            read_length[ 7:0]       <= rx_out;
                            ramp_enable             <= ramp_enable;
                            dc_enable               <= 0;
                            state                   <= state;
                        end
                    end else begin
                        counter                 <= counter;
                    end
                end

                S_READ_DATA_DC     : begin
                    PING_PONG_trig              <= 0;
                    set_min                     <= 0;
                    set_max                     <= 0;
                    dc_input                    <= dc_input;
                    PONG                        <= 0;
                    ramp_enable                 <= 0; 
                    if (rx_out_pulse) begin
                        counter                 <= counter + 1;
                        if (counter) begin
                            read_length[15:8]   <= rx_out;
                            dc_enable           <= 0;     
                            state               <= S_IDLE;    
                        end else begin
                            read_length[ 7:0]   <= rx_out;
                            dc_enable           <= dc_enable;
                            ramp_enable         <= 0;
                            state               <= state;
                        end
                    end else begin
                        counter                 <= counter;
                    end

                end
               
            endcase
        end
    end



    UART_RX                 U_RX_test(
        .clk                (clk                ),
        .rst                (rst                ),
        .serial_in          (serial_in          ),
        .rx_out             (rx_out             ),
        .rx_out_pulse       (rx_out_pulse       )
    );
endmodule
