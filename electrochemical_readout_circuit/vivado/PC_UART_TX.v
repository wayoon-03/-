
// simple uart_tx by tomato (moore version) //

module PC_UART_TX (
	input          clk,
	input   [7:0]  tx_data,
	input          rst_n,
	input          trigger,
	output reg     tx_output
);

	parameter			IDLE_ST= 4'd0,
					START_ST= 4'd1,
					D0_ST= 4'd2,
					D1_ST= 4'd3,
					D2_ST= 4'd4,
					D3_ST= 4'd5,
					D4_ST= 4'd6,
					D5_ST= 4'd7,
					D6_ST= 4'd8,
					D7_ST= 4'd9,
					STOP_ST= 4'd10;

	reg [3:0] tx_state;
	reg [31:0] clk_count;

	//OUTPUT LOGIC
	
	always @* begin
		case(tx_state) 
			IDLE_ST  : tx_output <= 1;
			START_ST : tx_output <= 0;
			D0_ST		: tx_output <= tx_data[0];
			D1_ST		: tx_output <= tx_data[1];
			D2_ST		: tx_output <= tx_data[2];
			D3_ST		: tx_output <= tx_data[3];
			D4_ST		: tx_output <= tx_data[4];
			D5_ST		: tx_output <= tx_data[5];
			D6_ST		: tx_output <= tx_data[6];
		   	D7_ST		: tx_output <= tx_data[7];
			STOP_ST  : tx_output <= 1;
			default  : tx_output <= 1; 
		endcase
	end
	
	//STATE REGISTER
	
always @(posedge clk or posedge rst_n) begin
		if(rst_n) begin
			tx_state <= IDLE_ST;
			clk_count <= 0;
		end	else if (trigger) begin
		    tx_state <=  START_ST;
		end else begin
			if(clk_count == 1) begin 
				clk_count <= 0;
				case(tx_state) 
						START_ST : 	tx_state <= D0_ST;
						D0_ST		: tx_state <= D1_ST;
						D1_ST		: tx_state <= D2_ST;
						D2_ST		: tx_state <= D3_ST;
						D3_ST		: tx_state <= D4_ST;
						D4_ST		: tx_state <= D5_ST;
						D5_ST		: tx_state <= D6_ST;
						D6_ST		: tx_state <= D7_ST;
						D7_ST		: tx_state <= STOP_ST;
						STOP_ST  : tx_state <= IDLE_ST;
						default  : tx_state <= IDLE_ST;
				endcase
			end else clk_count <= (tx_state == IDLE_ST ) ? 0 : clk_count + 1;
		end 
	end
endmodule
