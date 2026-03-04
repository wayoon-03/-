`timescale 1ns / 1ps

module RAMP(
    input               clk,
    input               rst,
    input               trig,
    input               ramp_enable,
    input               dc_enable,
    input       [15:0]  set_min,
    input       [15:0]  set_max,
    input       [15:0]  read_length,
    input       [15:0]  dc_input,
    output  reg [2:0]   state,
    output  reg [15:0]  ramp_out,
    output  reg [5:0]   delay_cnt,
    output  reg [15:0]  read_cnt
);

// RAMP FSM 상태 정의
parameter   ST_IDLE     = 3'b000;
parameter   ST_RISE     = 3'b001;
parameter   ST_FALL     = 3'b010;

parameter   V_CNT       = 6'd43;

// 내부 레지스터
reg [15:0] ramp_out_ramp;
reg [15:0] ramp_out_dc;
reg [15:0] read_cnt_ramp;
reg [15:0] read_cnt_dc;
reg [2:0]  dc_state;
reg [2:0]  dc_next_state;
reg        dc_trig;
reg        stop_enable;
reg [5:0]  delay_cnt_dc;
reg [5:0]  delay_cnt_ramp;
reg [15:0] read_cnt_muxed;
reg [15:0] ramp_out_muxed;
reg [5:0]  delay_cnt_muxed;

// DC FSM 상태 정의
parameter DC_IDLE   = 3'd0;
parameter DC_OUT    = 3'd1;
parameter DC_STOP   = 3'd2;

// DC FSM 동작 (ramp 방식처럼 재구성)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dc_state     <= DC_IDLE;
        ramp_out_dc  <= 16'd0;
        read_cnt_dc  <= 16'd0;
        delay_cnt_dc <= 6'd0;
        dc_trig      <= 1'b0;
        stop_enable  <= 1'b0;
    end else begin
        case (dc_state)
            DC_IDLE: begin
                ramp_out_dc  <= 16'd0;
                read_cnt_dc  <= 16'd0;
                delay_cnt_dc <= 6'd0;
                dc_trig      <= 1'b0;
                stop_enable  <= 1'b0;

                if (dc_enable) begin
                    dc_state <= DC_OUT;
                end else begin
                    dc_state <= DC_IDLE;
                end
            end

            DC_OUT: begin
                ramp_out_dc <= dc_input; // DC 출력 유지
            
                if (delay_cnt_dc < V_CNT) begin
                    delay_cnt_dc <= delay_cnt_dc + 6'd1;
                end else begin
                    delay_cnt_dc <= 6'd0;
            
                    // dc_enable이 LOW로 떨어지면 stop_enable 켜기
                    if (!dc_enable) begin
                        stop_enable <= 1'b1;
                    end
            
                    // stop_enable이 켜졌을 때 read_cnt 증가
                    if (stop_enable) begin
                        read_cnt_dc <= read_cnt_dc + 16'd1;
                    end
                end
            
                // read_cnt_dc가 다 끝나면 IDLE로 복귀
                if (read_cnt_dc == read_length + 1) begin
                    dc_state     <= DC_IDLE;
//                    ramp_out_dc  <= 16'd0;
                    read_cnt_dc  <= 16'd0;
                    delay_cnt_dc <= 6'd0;
                    dc_trig      <= 1'b0;
                    stop_enable  <= 1'b0;
                end
            end 
    endcase // ✅ 이 줄 추가!
    end
end
// RAMP FSM 동작
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state         <= ST_IDLE;
        ramp_out_ramp <= 16'd0;
        delay_cnt_ramp     <= 6'd0;
        read_cnt_ramp <= 16'd0;
    end else if (!dc_enable) begin
        case (state)
            ST_IDLE: begin
                ramp_out_ramp <= set_min;
                delay_cnt_ramp     <= 6'd0;
                read_cnt_ramp <= 16'd0;
                if (ramp_enable)
                    state <= ST_RISE;
            end
            ST_RISE: begin
                if (delay_cnt_ramp == V_CNT) begin
                    delay_cnt_ramp     <= 6'd0;
                    ramp_out_ramp <= ramp_out_ramp + 16'd1;
                    read_cnt_ramp <= (!ramp_enable) ? read_cnt_ramp + 16'd1 : 16'd0;
                end else begin
                    delay_cnt_ramp <= delay_cnt_ramp + 6'd1;
                end
                if (ramp_enable) begin
                    state <= (ramp_out_ramp == set_max) ? ST_FALL : state;
                end else begin
                    state <= (read_cnt_ramp == read_length + 1) ? ST_IDLE :
                             (ramp_out_ramp == set_max) ? ST_FALL : state;
                end
            end
            ST_FALL: begin
                if (delay_cnt_ramp == V_CNT) begin
                    delay_cnt_ramp     <= 6'd0;
                    ramp_out_ramp <= ramp_out_ramp - 16'd1;
                    read_cnt_ramp <= (!ramp_enable) ? read_cnt_ramp + 16'd1 : 16'd0;
                end else begin
                    delay_cnt_ramp <= delay_cnt_ramp + 6'd1;
                end
                if (ramp_enable) begin
                    state <= (ramp_out_ramp == set_min) ? ST_RISE : state;
                end else begin
                    state <= (read_cnt_ramp == read_length + 1) ? ST_IDLE :
                             (ramp_out_ramp == set_min) ? ST_RISE : state;
                end
            end
        endcase
    end
end

// FSM 상태 기반으로 MUX 제어 신호 생성
wire use_dc_output;
assign use_dc_output = (dc_state != DC_IDLE);  // DC FSM이 ACTIVE한 동안에는 DC 출력 사용

// 1단계: MUX 선택 (FSM 상태 기반)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        read_cnt_muxed  <= 16'd0;
        ramp_out_muxed  <= 16'd0;
        delay_cnt_muxed <= 6'd0;
    end else begin
        if (use_dc_output) begin
            read_cnt_muxed  <= read_cnt_dc;
            ramp_out_muxed  <= ramp_out_dc;
            delay_cnt_muxed <= delay_cnt_dc;
        end else begin
            read_cnt_muxed  <= read_cnt_ramp;
            ramp_out_muxed  <= ramp_out_ramp;
            delay_cnt_muxed <= delay_cnt_ramp;
        end
    end
end

// 2단계: 최종 출력 (레지스터에 동기화)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        read_cnt  <= 16'd0;
        ramp_out  <= 16'd0;
        delay_cnt <= 6'd0;
    end else begin
        read_cnt  <= read_cnt_muxed;
        ramp_out  <= ramp_out_muxed;
        delay_cnt <= delay_cnt_muxed;
    end
end

endmodule
