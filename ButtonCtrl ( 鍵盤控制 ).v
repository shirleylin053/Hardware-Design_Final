`timescale 1ns / 1ps
module ButtonCtrl(
	output reg key_0,
	output reg key_1,
	output reg key_2,
	output reg key_3,
	output reg key_4,
	output reg key_5,
	output reg key_6,
	output reg key_7,
	output reg key_8,
	output reg key_9,
	output reg key_enter,
	output reg key_correct,
	output reg key_back,
	output reg key_a,
	output reg key_b,
	output reg key_c,
	output reg key_d,
	output reg key_e,
	output reg key_f,
	output reg key_yes,
	output reg key_no,
	input wire clk,
	input wire rst,
	inout wire PS2_DATA,
	inout wire PS2_CLK
);

	parameter [8:0] KEY_CODES [0:21] = {
		9'b0_0111_0000, // right_0 => 70
		9'b0_0110_1001, // right_1 => 69
		9'b0_0111_0010, // right_2 => 72
		9'b0_0111_1010, // right_3 => 7A
		9'b0_0110_1011, // right_4 => 6B
		9'b0_0111_0011, // right_5 => 73
		9'b0_0111_0100, // right_6 => 74
		9'b0_0110_1100, // right_7 => 6C
		9'b0_0111_0101, // right_8 => 75
		9'b0_0111_1101, // right_9 => 7D
		
		9'b0_0101_1010, // ENTER => 5A
		
		9'b0_0110_0110, // backspace => 66

		9'b0_0101_1001, // right_shift_codes => 59
		9'b0_0001_0010, // left_shift_codes => 12
		
		9'b0_0001_1100, // A => 1C
		9'b0_0011_0010, // B => 32
		9'b0_0010_0001, // C => 21
		9'b0_0010_0011, // D => 23
		9'b0_0010_0100, // E => 24
		9'b0_0010_1011, // F => 2B
		
		9'b0_0100_0100, // O => 44
		9'b0_0010_0010  // X => 22
		
	};
	

	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
	

	KeyboardDecoder key_de (.key_down(key_down), .last_change(last_change), .key_valid(been_ready), .PS2_DATA(PS2_DATA), .PS2_CLK(PS2_CLK), .rst(rst), .clk(clk));
	
	always @ (posedge clk, posedge rst) begin
		if (rst) begin
			key_0  <= 1'b0;
			key_1  <= 1'b0;
			key_2  <= 1'b0;
			key_3  <= 1'b0;
			key_4  <= 1'b0;
			key_5  <= 1'b0;
			key_6  <= 1'b0;
			key_7  <= 1'b0;
			key_8  <= 1'b0;
			key_9  <= 1'b0;
			key_enter  <= 1'b0;
			key_correct  <= 1'b0;
			key_back  <= 1'b0;
			key_a  <= 1'b0;
			key_b  <= 1'b0;
			key_c  <= 1'b0;
			key_d  <= 1'b0;
			key_e  <= 1'b0;
			key_f  <= 1'b0;
			key_yes  <= 1'b0;
			key_no  <= 1'b0;
		end else begin
			key_0  <= 1'b0;
			key_1  <= 1'b0;
			key_2  <= 1'b0;
			key_3  <= 1'b0;
			key_4  <= 1'b0;
			key_5  <= 1'b0;
			key_6  <= 1'b0;
			key_7  <= 1'b0;
			key_8  <= 1'b0;
			key_9  <= 1'b0;
			key_enter  <= 1'b0;
			key_correct  <= 1'b0;
			key_back  <= 1'b0;
			key_a  <= 1'b0;
			key_b  <= 1'b0;
			key_c  <= 1'b0;
			key_d  <= 1'b0;
			key_e  <= 1'b0;
			key_f  <= 1'b0;
			key_yes  <= 1'b0;
			key_no  <= 1'b0;
			if (been_ready && key_down[last_change] == 1'b1) begin
				if (last_change == KEY_CODES[0]) key_0  <= 1'b1;
				if (last_change == KEY_CODES[1]) key_1  <= 1'b1;
				if (last_change == KEY_CODES[2]) key_2  <= 1'b1;
				if (last_change == KEY_CODES[3]) key_3  <= 1'b1;
				if (last_change == KEY_CODES[4]) key_4  <= 1'b1;
				if (last_change == KEY_CODES[5]) key_5  <= 1'b1;
				if (last_change == KEY_CODES[6]) key_6  <= 1'b1;
				if (last_change == KEY_CODES[7]) key_7  <= 1'b1;
				if (last_change == KEY_CODES[8]) key_8  <= 1'b1;
				if (last_change == KEY_CODES[9]) key_9  <= 1'b1;
				if (last_change == KEY_CODES[10]) key_enter  <= 1'b1;
				if (last_change == KEY_CODES[11]) key_correct  <= 1'b1;
				if (last_change == KEY_CODES[12]) key_back  <= 1'b1;
				if (last_change == KEY_CODES[13]) key_back  <= 1'b1;
				if (last_change == KEY_CODES[14]) key_a  <= 1'b1;
				if (last_change == KEY_CODES[15]) key_b  <= 1'b1;
				if (last_change == KEY_CODES[16]) key_c  <= 1'b1;
				if (last_change == KEY_CODES[17]) key_d  <= 1'b1;
				if (last_change == KEY_CODES[18]) key_e  <= 1'b1;
				if (last_change == KEY_CODES[19]) key_f  <= 1'b1;
				if (last_change == KEY_CODES[20]) key_yes  <= 1'b1;
				if (last_change == KEY_CODES[21]) key_no  <= 1'b1;
			end
		end
	end	

endmodule
