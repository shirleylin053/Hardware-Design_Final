module ATM_FSM(which_place, state, led_password_1, led_password_2, led_password_3, led_password_4, led_password_5, led_password_6, state_keyin_pass, state_chose_item, state_keyin_card, state_decide_howmuch, state_put_in, state_trans_money, state_keep_transc_not, state_money_not_enough, state_keyin_wrong, BCD1, BCD0, warning, music_front_on, music_after_on, clk_1sec, clk16, reset, take_money, card_1, card_2, card_3, card_4, card_5, key_0, key_1, key_2, key_3, key_4, key_5, key_6, key_7, key_8, key_9, key_enter,
	key_correct, key_back, key_a, key_b, key_c, key_d, key_e, key_yes, key_no
    );
	 
input clk_1sec, clk16, reset, take_money;
input card_1, card_2, card_3, card_4, card_5;
input key_0, key_1, key_2, key_3, key_4, key_5, key_6, key_7, key_8, key_9;
input key_enter, key_correct, key_back;
input key_a, key_b, key_c, key_d, key_e;
input key_yes, key_no;
output warning;
output [3:0] BCD1, BCD0;
output music_front_on, music_after_on;
output state_keyin_pass, state_chose_item, state_keyin_card, state_decide_howmuch, state_put_in, state_trans_money, state_keep_transc_not, state_money_not_enough, state_keyin_wrong ; // LEDs - state
output led_password_1, led_password_2, led_password_3, led_password_4, led_password_5, led_password_6;
output [3:0]state;
output [2:0]which_place;


wire ke, ke2 ;
 
assign BCD0 = (state == count_down_money)? count_second1 % 10 : 
			  (state == count_down_card)? count_second2 % 10 : 
			  (state == keep_transc_not && card_1 == 1)? (money_card1 % 10000)/1000 :
			  (state == keep_transc_not && card_2 == 1)? (money_card2 % 10000)/1000 :
			  (state == keep_transc_not && card_3 == 1)? (money_card3 % 10000)/1000 :
			  (state == keep_transc_not && card_4 == 1)? (money_card4 % 10000)/1000 :
			  (state == keep_transc_not && card_5 == 1)? (money_card5 % 10000)/1000 :0;
			  
assign BCD1 = (state == count_down_money)? count_second1 / 10 : 
			  (state == count_down_card)? count_second2 / 10 :
			  (state == keep_transc_not && card_1 == 1)? money_card1 / 10000 :
			  (state == keep_transc_not && card_2 == 1)? money_card2 / 10000 :
			  (state == keep_transc_not && card_3 == 1)? money_card3 / 10000 :
			  (state == keep_transc_not && card_4 == 1)? money_card4 / 10000 :
			  (state == keep_transc_not && card_5 == 1)? money_card5 / 10000 :0;
			  
			  
assign warning = (card_1 == 0 && card_2 == 0 && card_3 == 0 && card_4 == 0 && card_5 == 0) ? 0 : 1; 
 
assign state_keyin_pass = (state == keyin_pass) ? 1:0;
assign state_chose_item = (state == chose_item) ? 1:0;
assign state_keyin_card = (state == keyin_card)?1:0;
assign state_decide_howmuch = (state == decide_howmuch)?1:0;
assign state_put_in = (state == put_in)?1:0;
assign state_trans_money = (state == trans_money) ? 1:0;
assign state_keep_transc_not = (state == keep_transc_not) ? 1:0;
assign state_money_not_enough = (state == money_not_enough) ? 1:0;
assign state_keyin_wrong = (state == keyin_wrong || state == keyin_wrong_2) ? 1:0;

assign led_password_1 = (which_place >= 1) ? 1:0;
assign led_password_2 = (which_place >= 2) ? 1:0;
assign led_password_3 = (which_place >= 3) ? 1:0;
assign led_password_4 = (which_place >= 4) ? 1:0;
assign led_password_5 = (which_place >= 5) ? 1:0;
assign led_password_6 = (which_place >= 6) ? 1:0;



wire clk_select;

reg [3:0] state;
reg [3:0] next_state;

reg [3:0] id_card1, id_card2; 
reg [3:0] next_id_card1;
reg [3:0] next_id_card2;
reg [19:0] temp_money;

reg [16:0] money_card1; 
reg [15:0] money_card2;
reg [14:0] money_card3;
reg [13:0] money_card4;
reg [12:0] money_card5;

reg [3:0] password_1, password_2, password_3, password_4, password_5, password_6; 

reg [3:0] comp_num_1, comp_num_2, comp_num_3, comp_num_4, comp_num_5, comp_num_6; 
reg [3:0] next_comp_num_1, next_comp_num_2, next_comp_num_3, next_comp_num_4, next_comp_num_5, next_comp_num_6;
reg [2:0] which_place;
reg [2:0] next_which_place;

reg [16:0] next_money_card1 ;
reg [15:0] next_money_card2 ;
reg [14:0] next_money_card3 ;
reg [13:0] next_money_card4 ;
reg [12:0] next_money_card5 ;

reg [4:0] next_count_second1;
reg [3:0] next_count_second2;

reg [19:0] next_temp_money;

reg [2:0] digit;
reg [2:0] next_digit;

reg [4:0] count_second1;
reg [3:0] count_second2;

reg flag; 
reg next_flag;

wire music_front_on;
wire music_after_on;

parameter insert_card = 4'b0000;
parameter keyin_pass = 4'b0001;
parameter chose_item = 4'b0010;
parameter keyin_card = 4'b0011;
parameter decide_howmuch = 4'b0100;
parameter put_in = 4'b0101;
parameter money_not_enough = 4'b0110;
parameter trans_money = 4'b1000;
parameter keep_transc_not = 4'b1001;
parameter keyin_wrong = 4'b1011; 
parameter keyin_wrong_2 = 4'b1100; 
parameter count_down_money = 4'b1101;
parameter count_down_card = 4'b1110;

assign music_front_on = (state == insert_card) ? 0 : 1;
assign music_after_on = (state == count_down_card)? 0 : 1;

assign clk_select = (state == count_down_money || state == count_down_card  || state == count_down_money) ? clk_1sec: clk16;


always@(posedge clk_select or posedge reset) begin
  if(reset) begin
    state <= insert_card;
	flag <= 0;
	id_card1 <= 0;
    temp_money <= 20'h00000;
	which_place <=0;
    money_card1 <= 40000;
	money_card2 <= 25000;
	money_card3 <= 20000;
	money_card4 <= 10000;
	money_card5 <= 4000;
	count_second1 <= 30;
	count_second2 <= 10;
	digit <= 0;
	comp_num_1 <= 0;
	comp_num_2 <= 0;
	comp_num_3 <= 0;
	comp_num_4 <= 0;
	comp_num_5 <= 0;
	comp_num_6 <= 0;
  end
  else begin
	id_card1 <= next_id_card1;
	id_card2 <= next_id_card2;
	flag <= next_flag;
	comp_num_1 <= next_comp_num_1;
	comp_num_2 <= next_comp_num_2;
	comp_num_3 <= next_comp_num_3;
	comp_num_4 <= next_comp_num_4;
	comp_num_5 <= next_comp_num_5;
	comp_num_6 <= next_comp_num_6;
	which_place <=next_which_place;
	state <= next_state;
	money_card1 <= next_money_card1;
	money_card2 <= next_money_card2;
	money_card3 <= next_money_card3;
	money_card4 <= next_money_card4;
	money_card5 <= next_money_card5;
	count_second1 <= next_count_second1;
	count_second2 <= next_count_second2;
	temp_money <= next_temp_money;
	digit <= next_digit;
  end	
end



always@( * ) begin
	case(state)
		insert_card: begin
			next_count_second1 <= count_second1;
			next_count_second2 <= count_second2;
			next_money_card1 <= money_card1;
			next_money_card2 <= money_card2;
			next_money_card3 <= money_card3;
			next_money_card4 <= money_card4;
			next_money_card5 <= money_card5;
			if(card_1 == 1) begin   // ?��?��??�入?��張卡??? 並設定卡??��?�碼
				next_id_card1 <= 1;
				next_state <= keyin_pass;
			end
			else if(card_2 == 1) begin
				next_id_card1 <= 2;
				next_state <= keyin_pass;
			end
			else if(card_3 == 1) begin
				next_id_card1 <= 3;
				next_state <= keyin_pass;
			end
			else if(card_4 == 1) begin
				next_id_card1 <= 4;
				next_state <= keyin_pass;
			end
			else if(card_5 == 1) begin
				next_id_card1 <= 5;
				next_state <= keyin_pass;
			end
			else begin
				next_id_card1 <= id_card1;
				next_state <= insert_card;
			end
		end
		keyin_pass:begin
			next_count_second1 <= count_second1;
			next_count_second2 <= count_second2;
			next_money_card1 <= money_card1;
			next_money_card2 <= money_card2;
			next_money_card3 <= money_card3;
			next_money_card4 <= money_card4;
			next_money_card5 <= money_card5;
			if(key_0 == 1) begin
				next_comp_num_1 <= comp_num_1;
				next_comp_num_2 <= comp_num_2;
				next_comp_num_3 <= comp_num_3;
				next_comp_num_4 <= comp_num_4;
				next_comp_num_5 <= comp_num_5;
				next_comp_num_6 <= comp_num_6;
				if(which_place == 0) begin
					next_comp_num_1 <= 0;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 1) begin
					next_comp_num_2 <= 0;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 2) begin
					next_comp_num_3 <= 0;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 3) begin
					next_comp_num_4 <= 0;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 4) begin
					next_comp_num_5 <= 0;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 5) begin
					next_comp_num_6 <= 0;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
			end
			
			else if(key_1 == 1) begin
				next_comp_num_1 <= comp_num_1;
				next_comp_num_2 <= comp_num_2;
				next_comp_num_3 <= comp_num_3;
				next_comp_num_4 <= comp_num_4;
				next_comp_num_5 <= comp_num_5;
				next_comp_num_6 <= comp_num_6;
				if(which_place == 0) begin
					next_comp_num_1 <= 1;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 1) begin
					next_comp_num_2 <= 1;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 2) begin
					next_comp_num_3 <= 1;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 3) begin
					next_comp_num_4 <= 1;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 4) begin
					next_comp_num_5 <= 1;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 5) begin
					next_comp_num_6 <= 1;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
			end
			
			else if(key_2 == 1) begin
				next_comp_num_1 <= comp_num_1;
				next_comp_num_2 <= comp_num_2;
				next_comp_num_3 <= comp_num_3;
				next_comp_num_4 <= comp_num_4;
				next_comp_num_5 <= comp_num_5;
				next_comp_num_6 <= comp_num_6;
				if(which_place == 0) begin
					next_comp_num_1 <= 2;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 1) begin
					next_comp_num_2 <= 2;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 2) begin
					next_comp_num_3 <= 2;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 3) begin
					next_comp_num_4 <= 2;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 4) begin
					next_comp_num_5 <= 2;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 5) begin
					next_comp_num_6 <= 2;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
			end
			
			else if(key_3 == 1) begin
				next_comp_num_1 <= comp_num_1;
				next_comp_num_2 <= comp_num_2;
				next_comp_num_3 <= comp_num_3;
				next_comp_num_4 <= comp_num_4;
				next_comp_num_5 <= comp_num_5;
				next_comp_num_6 <= comp_num_6;
				if(which_place == 0) begin
					next_comp_num_1 <= 3;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 1) begin
					next_comp_num_2 <= 3;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 2) begin
					next_comp_num_3 <= 3;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 3) begin
					next_comp_num_4 <= 3;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 4) begin
					next_comp_num_5 <= 3;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 5) begin
					next_comp_num_6 <= 3;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
			end
			
			else if(key_4 == 1) begin
				next_comp_num_1 <= comp_num_1;
				next_comp_num_2 <= comp_num_2;
				next_comp_num_3 <= comp_num_3;
				next_comp_num_4 <= comp_num_4;
				next_comp_num_5 <= comp_num_5;
				next_comp_num_6 <= comp_num_6;
				if(which_place == 0) begin
					next_comp_num_1 <= 4;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 1) begin
					next_comp_num_2 <= 4;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 2) begin
					next_comp_num_3 <= 4;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 3) begin
					next_comp_num_4 <= 4;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 4) begin
					next_comp_num_5 <= 4;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 5) begin
					next_comp_num_6 <= 4;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
			end
			
			else if(key_5 == 1) begin
				next_comp_num_1 <= comp_num_1;
				next_comp_num_2 <= comp_num_2;
				next_comp_num_3 <= comp_num_3;
				next_comp_num_4 <= comp_num_4;
				next_comp_num_5 <= comp_num_5;
				next_comp_num_6 <= comp_num_6;
				if(which_place == 0) begin
					next_comp_num_1 <= 5;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 1) begin
					next_comp_num_2 <= 5;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 2) begin
					next_comp_num_3 <= 5;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 3) begin
					next_comp_num_4 <= 5;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 4) begin
					next_comp_num_5 <= 5;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 5) begin
					next_comp_num_6 <= 5;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
			end
			
			else if(key_6 == 1) begin
				next_comp_num_1 <= comp_num_1;
				next_comp_num_2 <= comp_num_2;
				next_comp_num_3 <= comp_num_3;
				next_comp_num_4 <= comp_num_4;
				next_comp_num_5 <= comp_num_5;
				next_comp_num_6 <= comp_num_6;
				if(which_place == 0) begin
					next_comp_num_1 <= 6;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 1) begin
					next_comp_num_2 <= 6;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 2) begin
					next_comp_num_3 <= 6;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 3) begin
					next_comp_num_4 <= 6;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 4) begin
					next_comp_num_5 <= 6;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 5) begin
					next_comp_num_6 <= 6;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
			end
			
			else if(key_7 == 1) begin
				next_comp_num_1 <= comp_num_1;
				next_comp_num_2 <= comp_num_2;
				next_comp_num_3 <= comp_num_3;
				next_comp_num_4 <= comp_num_4;
				next_comp_num_5 <= comp_num_5;
				next_comp_num_6 <= comp_num_6;
				if(which_place == 0) begin
					next_comp_num_1 <= 7;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 1) begin
					next_comp_num_2 <= 7;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 2) begin
					next_comp_num_3 <= 7;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 3) begin
					next_comp_num_4 <= 7;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 4) begin
					next_comp_num_5 <= 7;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 5) begin
					next_comp_num_6 <= 7;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
			end
			
			else if(key_8 == 1) begin
				next_comp_num_1 <= comp_num_1;
				next_comp_num_2 <= comp_num_2;
				next_comp_num_3 <= comp_num_3;
				next_comp_num_4 <= comp_num_4;
				next_comp_num_5 <= comp_num_5;
				next_comp_num_6 <= comp_num_6;
				if(which_place == 0) begin
					next_comp_num_1 <= 8;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 1) begin
					next_comp_num_2 <= 8;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 2) begin
					next_comp_num_3 <= 8;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 3) begin
					next_comp_num_4 <= 8;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 4) begin
					next_comp_num_5 <= 8;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 5) begin
					next_comp_num_6 <= 8;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
			end
			
			else if(key_9 == 1) begin
				next_comp_num_1 <= comp_num_1;
				next_comp_num_2 <= comp_num_2;
				next_comp_num_3 <= comp_num_3;
				next_comp_num_4 <= comp_num_4;
				next_comp_num_5 <= comp_num_5;
				next_comp_num_6 <= comp_num_6;
				if(which_place == 0) begin
					next_comp_num_1 <= 9;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 1) begin
					next_comp_num_2 <= 9;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 2) begin
					next_comp_num_3 <= 9;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 3) begin
					next_comp_num_4 <= 9;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 4) begin
					next_comp_num_5 <= 9;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
				else if(which_place == 5) begin
					next_comp_num_6 <= 9;
					next_which_place <= which_place + 1;
					next_state <= keyin_pass;
				end
			end

			else if(key_correct == 1) begin
				next_which_place <= 0;
				next_state <= keyin_pass;
			end
			
			else if(key_enter == 1 && which_place == 6 && id_card1 == 1) begin
			     if(comp_num_1 == 9&& comp_num_2 == 4 && comp_num_3 == 2 && comp_num_4 == 7 && comp_num_5 == 6 && comp_num_6 ==0)begin  
			         next_which_place <= 0;
                     next_state <= chose_item;
			     end
			     else begin
                      next_which_place <= 0;
                      next_state <= keyin_wrong;
			     end
			end
			else if(key_enter == 1 && which_place == 6 && id_card1 == 2) begin
			     if(comp_num_1 == 1 && comp_num_2 == 2 && comp_num_3 == 2 && comp_num_4 == 7 && comp_num_5 == 6 && comp_num_6 == 8)begin  
			         next_which_place <= 0;
                     next_state <= chose_item;
			     end
			     else begin
                      next_which_place <= 0;
                      next_state <= keyin_wrong;
			     end
			end
			else if(key_enter == 1 && which_place == 6 && id_card1 == 3) begin
			     if(comp_num_1 == 0&& comp_num_2 == 4 && comp_num_3 == 5 && comp_num_4 == 2 && comp_num_5 == 1 && comp_num_6 == 3)begin  
			         next_which_place <= 0;
                     next_state <= chose_item;
			     end
			     else begin
                      next_which_place <= 0;
                      next_state <= keyin_wrong;
			     end
			end
			else if(key_enter == 1 && which_place == 6 && id_card1 == 4) begin
			     if(comp_num_1 == 7 && comp_num_2 == 9 && comp_num_3 == 3 && comp_num_4 == 5 && comp_num_5 == 0 && comp_num_6 ==8)begin  
			         next_which_place <= 0;
                     next_state <= chose_item;
			     end
			     else begin
                      next_which_place <= 0;
                      next_state <= keyin_wrong;
			     end
			end
			else if(key_enter == 1 && which_place == 6 && id_card1 == 5) begin
			     if(comp_num_1 == 8 && comp_num_2 == 4 && comp_num_3 == 4 && comp_num_4 == 3 && comp_num_5 == 9 && comp_num_6 == 4)begin  
			         next_which_place <= 0;
                     next_state <= chose_item;
			     end
			     else begin
                      next_which_place <= 0;
                      next_state <= keyin_wrong;
			     end
			end
			else if(key_enter == 1 && which_place !=6)begin
					next_which_place <= 0;
                    next_state <= keyin_wrong;
			end
			else begin
				next_comp_num_1 <= comp_num_1;
				next_comp_num_2 <= comp_num_2;
				next_comp_num_3 <= comp_num_3;
				next_comp_num_4 <= comp_num_4;
				next_comp_num_5 <= comp_num_5;
				next_comp_num_6 <= comp_num_6;
				next_which_place <= which_place ;
				next_state <= keyin_pass;
			end
		end
		keyin_wrong: begin
			next_count_second1 <= count_second1;
			next_count_second2 <= count_second2;
			next_money_card1 <= money_card1;
			next_money_card2 <= money_card2;
			next_money_card3 <= money_card3;
			next_money_card4 <= money_card4;
			next_money_card5 <= money_card5;
			if(key_enter) begin
				next_state <= keyin_pass;
			end
			else begin
				next_state <= keyin_wrong;
			end
		end
		chose_item:begin
			next_count_second1 <= count_second1;
			next_count_second2 <= count_second2;
			next_money_card1 <= money_card1;
			next_money_card2 <= money_card2;
			next_money_card3 <= money_card3;
			next_money_card4 <= money_card4;
			next_money_card5 <= money_card5;
			if(key_a) begin
				next_state <= decide_howmuch;
				next_flag <=0;
			end
			else if(key_b) begin
				next_state <= keyin_card;
				next_flag <=1;
			end
			else if(key_c) begin
				next_state <= keep_transc_not;
				next_flag <=0;
			end
			else begin
				next_state <= chose_item;
				next_flag <=0;
			end
		end
		keyin_card:begin
			next_flag <= flag;
			next_count_second1 <= count_second1;
			next_count_second2 <= count_second2;
			next_money_card1 <= money_card1;
			next_money_card2 <= money_card2;
			next_money_card3 <= money_card3;
			next_money_card4 <= money_card4;
			next_money_card5 <= money_card5;
			if(key_1) begin
				next_id_card2 <= 1;
				next_state <= keyin_card;
			end
			else if(key_2) begin
				next_id_card2 <= 2;
				next_state <= keyin_card;
			end
			else if(key_3) begin
				next_id_card2 <= 3;
				next_state <= keyin_card;
			end
			else if(key_4) begin
				next_id_card2 <= 4;
				next_state <= keyin_card;				
			end
			else if(key_5) begin
				next_id_card2 <= 5;
				next_state <= keyin_card;	
			end
			else if(key_enter && (id_card2 != 0)) begin
				next_state <= decide_howmuch;	
			end
			else if(key_correct) begin
				next_id_card2 <= 0;
				next_state <= keyin_card;	
			end
			else begin
			    next_id_card2 <= id_card2;
				next_state <= keyin_card;
			end
		end
		decide_howmuch:begin
			next_flag <= flag;
			next_count_second1 <= count_second1;
			next_count_second2 <= count_second2;
			next_money_card1 <= money_card1;
			next_money_card2 <= money_card2;
			next_money_card3 <= money_card3;
			next_money_card4 <= money_card4;
			next_money_card5 <= money_card5;
			if(key_a) begin
				next_state <= put_in;
			end
			else if(key_b) begin
					if(id_card1 == 1 && money_card1 >= 1000 && flag == 0) begin
						next_money_card1 <= money_card1 - 1000;
						next_state <= count_down_money;
						next_temp_money <= 1000;
					end
					else if(id_card1 == 2 && money_card2 >= 1000 && flag == 0) begin
						next_money_card2 <= money_card2 - 1000;
						next_state <= count_down_money;
						next_temp_money <= 1000;
					end
					else if(id_card1 == 3 && money_card3 >= 1000 && flag == 0) begin
						next_money_card3 <= money_card3 - 1000;
						next_state <= count_down_money;
						next_temp_money <= 1000;
					end
					else if(id_card1 == 4 && money_card4 >= 1000 && flag == 0) begin
						next_money_card4 <= money_card4 - 1000;
						next_state <= count_down_money;
						next_temp_money <= 1000;
					end
					else if(id_card1 == 5 && money_card5 >= 1000 && flag == 0) begin
						next_money_card5 <= money_card5 - 1000;
						next_state <= count_down_money;
						next_temp_money <= 1000;
					end
					else if(id_card1 == 1 && money_card1 >= 1000 && flag == 1) begin
						next_money_card1 <= money_card1 - 1000;
						next_state <= trans_money;
						next_temp_money <= 1000;
					end
					else if(id_card1 == 2 && money_card2 >= 1000 && flag == 1) begin
						next_money_card2 <= money_card2 - 1000;
						next_state <= trans_money;
						next_temp_money <= 1000;
					end
					else if(id_card1 == 3 && money_card3 >= 1000 && flag == 1) begin
						next_money_card3 <= money_card3 - 1000;
						next_state <= trans_money;
						next_temp_money <= 1000;
					end
					else if(id_card1 == 4 && money_card4 >= 1000 && flag == 1) begin
						next_money_card4 <= money_card4 - 1000;
						next_state <= trans_money;
						next_temp_money <= 1000;
					end
					else if(id_card1 == 5 && money_card5 >= 1000 && flag == 1) begin
						next_money_card5 <= money_card5 - 1000;
						next_state <= trans_money;
						next_temp_money <= 1000;
					end
					else begin
						next_state <= money_not_enough;
					end
			end
			else if(key_c) begin
					next_money_card1 <= money_card1;
					next_money_card2 <= money_card2;
					next_money_card3 <= money_card3;
					next_money_card4 <= money_card4;
					next_money_card5 <= money_card5;
					if(id_card1 == 1 && money_card1 >= 2000 && flag == 0) begin
						next_money_card1 <= money_card1 - 2000;
						next_state <= count_down_money;
						next_temp_money <= 2000;
					end
					else if(id_card1 == 2 && money_card2 >= 2000 && flag == 0) begin
						next_money_card2 <= money_card2 - 2000;
						next_state <= count_down_money;
						next_temp_money <= 2000;
					end
					else if(id_card1 == 3 && money_card3 >= 2000 && flag == 0) begin
						next_money_card3 <= money_card3 - 2000;
						next_state <= count_down_money;
						next_temp_money <= 2000;
					end
					else if(id_card1 == 4 && money_card4 >= 2000 && flag == 0) begin
						next_money_card4 <= money_card4 - 2000;
						next_state <= count_down_money;
						next_temp_money <= 2000;
					end
					else if(id_card1 == 5 && money_card5 >= 2000 && flag == 0) begin
						next_money_card5 <= money_card5 - 2000;
						next_state <= count_down_money;
						next_temp_money <= 2000;
					end
					else if(id_card1 == 1 && money_card1 >= 2000 && flag == 1) begin
						next_money_card1 <= money_card1 - 2000;
						next_state <= trans_money;
						next_temp_money <= 2000;
					end
					else if(id_card1 == 2 && money_card2 >= 2000 && flag == 1) begin
						next_money_card2 <= money_card2 - 2000;
						next_state <= trans_money;
						next_temp_money <= 2000;
					end
					else if(id_card1 == 3 && money_card3 >= 2000 && flag == 1) begin
						next_money_card3 <= money_card3 - 2000;
						next_state <= trans_money;
						next_temp_money <= 2000;
					end
					else if(id_card1 == 4 && money_card4 >= 2000 && flag == 1) begin
						next_money_card4 <= money_card4 - 2000;
						next_state <= trans_money;
						next_temp_money <= 2000;
					end
					else if(id_card1 == 5 && money_card5 >= 2000 && flag == 1) begin
						next_money_card5 <= money_card5 - 2000;
						next_state <= trans_money;
						next_temp_money <= 2000;
					end
					
					else begin
						next_state <= money_not_enough;
					end
			end
			else if(key_d) begin
					next_money_card1 <= money_card1;
					next_money_card2 <= money_card2;
					next_money_card3 <= money_card3;
					next_money_card4 <= money_card4;
					next_money_card5 <= money_card5;
					if(id_card1 == 1 && money_card1 >= 5000 && flag == 0) begin
						next_money_card1 <= money_card1 - 5000;
						next_state <= count_down_money;
						next_temp_money <= 5000;
					end
					else if(id_card1 == 2 && money_card2 >= 5000 && flag == 0) begin
						next_money_card2 <= money_card2 - 5000;
						next_state <= count_down_money;
						next_temp_money <= 5000;
					end
					else if(id_card1 == 3 && money_card3 >= 5000 && flag == 0) begin
						next_money_card3 <= money_card3 - 5000;
						next_state <= count_down_money;
						next_temp_money <= 5000;
					end
					else if(id_card1 == 4 && money_card4 >= 5000 && flag == 0) begin
						next_money_card4 <= money_card4 - 5000;
						next_state <= count_down_money;
						next_temp_money <= 5000;
					end
					else if(id_card1 == 5 && money_card5 >= 5000 && flag == 0) begin
						next_money_card5 <= money_card5 - 5000;
						next_state <= count_down_money;
						next_temp_money <= 5000;
					end
					else if(id_card1 == 1 && money_card1 >= 5000 && flag == 1) begin
						next_money_card1 <= money_card1 - 5000;
						next_state <= trans_money;
						next_temp_money <= 5000;
					end
					else if(id_card1 == 2 && money_card2 >= 5000 && flag == 1) begin
						next_money_card2 <= money_card2 - 5000;
						next_state <= trans_money;
						next_temp_money <= 5000;
					end
					else if(id_card1 == 3 && money_card3 >= 5000 && flag == 1) begin
						next_money_card3 <= money_card3 - 5000;
						next_state <= trans_money;
						next_temp_money <= 5000;
					end
					else if(id_card1 == 4 && money_card4 >= 5000 && flag == 1) begin
						next_money_card4 <= money_card4 - 5000;
						next_state <= trans_money;
						next_temp_money <= 5000;
					end
					else if(id_card1 == 5 && money_card5 >= 5000 && flag == 1) begin
						next_money_card5 <= money_card5 - 5000;
						next_state <= trans_money;
						next_temp_money <= 5000;
					end
					else begin
						next_state <= money_not_enough;
					end
			end
			else if(key_e) begin
					next_money_card1 <= money_card1;
					next_money_card2 <= money_card2;
					next_money_card3 <= money_card3;
					next_money_card4 <= money_card4;
					next_money_card5 <= money_card5;
					if(id_card1 == 1 && money_card1 >= 10000 && flag == 0) begin
						next_money_card1 <= money_card1 - 10000;
						next_state <= count_down_money;
						next_temp_money <= 10000;
					end
					else if(id_card1 == 2 && money_card2 >= 10000 && flag == 0) begin
						next_money_card2 <= money_card2 - 10000;
						next_state <= count_down_money;
						next_temp_money <= 10000;
					end
					else if(id_card1 == 3 && money_card3 >= 10000 && flag == 0) begin
						next_money_card3 <= money_card3 - 10000;
						next_state <= count_down_money;
						next_temp_money <= 10000;
					end
					else if(id_card1 == 4 && money_card4 >= 10000 && flag == 0) begin
						next_money_card4 <= money_card4 - 10000;
						next_state <= count_down_money;
						next_temp_money <= 10000;
					end
					else if(id_card1 == 5 && money_card5 >= 10000 && flag == 0) begin
						next_money_card5 <= money_card5 - 10000;
						next_state <= count_down_money;
						next_temp_money <= 10000;
					end
					else if(id_card1 == 1 && money_card1 >= 10000 && flag == 1) begin
						next_money_card1 <= money_card1 - 10000;
						next_state <= trans_money;
						next_temp_money <= 10000;
					end
					else if(id_card1 == 2 && money_card2 >= 10000 && flag == 1) begin
						next_money_card2 <= money_card2 - 10000;
						next_state <= trans_money;
						next_temp_money <= 10000;
					end
					else if(id_card1 == 3 && money_card3 >= 10000 && flag == 1) begin
						next_money_card3 <= money_card3 - 10000;
						next_state <= trans_money;
						next_temp_money <= 10000;
					end
					else if(id_card1 == 4 && money_card4 >= 10000 && flag == 1) begin
						next_money_card4 <= money_card4 - 10000;
						next_state <= trans_money;
						next_temp_money <= 10000;
					end
					else if(id_card1 == 5 && money_card5 >= 10000 && flag == 1) begin
						next_money_card5 <= money_card5 - 10000;
						next_state <= trans_money;
						next_temp_money <= 10000;
					end
					else begin
						next_state <= money_not_enough;
					end
			end
			else begin
				next_money_card1 <= money_card1;
				next_money_card2 <= money_card2;
				next_money_card3 <= money_card3;
				next_money_card4 <= money_card4;
				next_money_card5 <= money_card5;
				next_temp_money <= temp_money;
				next_state <= decide_howmuch;
			end
		end
		put_in:begin
			next_flag <= flag;
			next_temp_money <= temp_money;
			next_count_second1 <= count_second1;
			next_count_second2 <= count_second2;
			next_money_card1 <= money_card1;
			next_money_card2 <= money_card2;
			next_money_card3 <= money_card3;
			next_money_card4 <= money_card4;
			next_money_card5 <= money_card5;
			if(key_0 && digit < 6) begin
				next_temp_money <= temp_money*10 + 0;
				next_digit <= digit +1;
				next_state <= put_in;
			end
			else if(key_1 && digit < 6) begin
				next_temp_money <= temp_money*10 + 1;
				next_digit <= digit +1;
				next_state <= put_in;
			end
			else if(key_2 && digit < 6) begin
				next_temp_money <= temp_money*10 + 2;
				next_digit <= digit +1;
				next_state <= put_in;
			end
			else if(key_3 && digit < 6) begin
				next_temp_money <= temp_money*10 + 3;
				next_digit <= digit +1;
				next_state <= put_in;
			end
			else if(key_4 && digit < 6) begin
				next_temp_money <= temp_money*10 + 4;
				next_digit <= digit +1;
				next_state <= put_in;
			end
			else if(key_5 && digit < 6) begin
				next_temp_money <= temp_money*10 + 5;
				next_digit <= digit +1;
				next_state <= put_in;
			end
			else if(key_6 && digit < 6) begin
				next_temp_money <= temp_money*10 + 6;
				next_digit <= digit +1;
				next_state <= put_in;
			end
			else if(key_7 && digit < 6) begin
				next_temp_money <= temp_money*10 + 7;
				next_digit <= digit +1;
				next_state <= put_in;
			end
			else if(key_8 && digit < 6) begin
				next_temp_money <= temp_money*10 + 8;
				next_digit <= digit +1;
				next_state <= put_in;
			end
			else if(key_9 && digit < 6) begin
				next_temp_money <= temp_money*10 + 9;
				next_digit <= digit +1;
				next_state <= put_in;
			end
			else if(key_enter == 1 && temp_money <= 10000 && temp_money%1000 == 0 && temp_money != 0 && flag == 0) begin
					next_money_card1 <= money_card1;
					next_money_card2 <= money_card2;
					next_money_card3 <= money_card3;
					next_money_card4 <= money_card4;
					next_money_card5 <= money_card5;
					if(id_card1 == 1 && money_card1 >= temp_money) begin
						next_money_card1 <= money_card1 - temp_money;
						next_state <= count_down_money;
					end
					else if(id_card1 == 2 && money_card2 >= temp_money) begin 
						next_money_card2 <= money_card2 - temp_money;
						next_state <= count_down_money;
					end
					else if(id_card1 == 3 && money_card3 >= temp_money) begin 
						next_money_card3 <= money_card3 - temp_money;
						next_state <= count_down_money;
					end
					else if(id_card1 == 4 && money_card4 >= temp_money) begin 
						next_money_card4 <= money_card4 - temp_money;
						next_state <= count_down_money;
					end
					else if(id_card1 == 5 && money_card5 >= temp_money) begin 
						next_money_card5 <= money_card5 - temp_money;
						next_state <= count_down_money;
					end
					else begin
						next_state <= money_not_enough;
					end
			end
			else if(key_enter == 1 && temp_money%1000 == 0 && temp_money <= 10000 && temp_money != 0 && flag == 1) begin
					next_money_card1 <= money_card1;
					next_money_card2 <= money_card2;
					next_money_card3 <= money_card3;
					next_money_card4 <= money_card4;
					next_money_card5 <= money_card5;
					if(id_card1 == 1 && money_card1 >= temp_money) begin
						next_money_card1 <= money_card1 - temp_money;
						next_state <= trans_money;
					end
					else if(id_card1 == 2 && money_card2 >= temp_money) begin 
						next_money_card2 <= money_card2 - temp_money;
						next_state <= trans_money;
					end
					else if(id_card1 == 3 && money_card3 >= temp_money) begin 
						next_money_card3 <= money_card3 - temp_money;
						next_state <= trans_money;
					end
					else if(id_card1 == 4 && money_card4 >= temp_money) begin 
						next_money_card4 <= money_card4 - temp_money;
						next_state <= trans_money;
					end
					else if(id_card1 == 5 && money_card5 >= temp_money) begin 
						next_money_card5 <= money_card5 - temp_money;
						next_state <= trans_money;
					end
					else begin
						next_state <= money_not_enough;
					end
			end
			else if(key_enter == 1 && (temp_money > 10000 || temp_money == 0 || temp_money%1000 != 0)) begin
				next_temp_money <= 0;
				next_digit <= 0;
				next_state <= keyin_wrong_2;
			end
			else if(key_correct) begin
				next_temp_money <= 0;
				next_digit <= 0;
				next_state <= put_in;
			end
			else if(key_back) begin
				next_temp_money <= 0;
				next_digit <= 0;
				next_state <= decide_howmuch;
			end
			else begin
				next_digit <= digit;
				next_temp_money <= temp_money;
				next_state <= put_in;
			end
		end
		keyin_wrong_2:begin
			next_temp_money <= 0;
			next_digit <= 0;
			next_flag <= flag;
			next_count_second1 <= count_second1;
			next_count_second2 <= count_second2;
			next_money_card1 <= money_card1;
			next_money_card2 <= money_card2;
			next_money_card3 <= money_card3;
			next_money_card4 <= money_card4;
			next_money_card5 <= money_card5;
			if(key_enter) begin
				next_state <= put_in;
			end
			else begin
				next_state <= keyin_wrong_2;
			end
		end
		
		
		
		money_not_enough:begin
			next_temp_money <= 0;
			next_digit <= 0;
			next_flag <= flag;
			next_count_second1 <= count_second1;
			next_count_second2 <= count_second2;
			next_money_card1 <= money_card1;
			next_money_card2 <= money_card2;
			next_money_card3 <= money_card3;
			next_money_card4 <= money_card4;
			next_money_card5 <= money_card5;
			if(key_enter) begin
				next_state <= keep_transc_not;
			end
			else begin
				next_state <= money_not_enough;
			end
		end
		count_down_money:begin
			next_count_second1 <= count_second1;
			next_count_second2 <= count_second2;
			next_money_card1 <= money_card1;
			next_money_card2 <= money_card2;
			next_money_card3 <= money_card3;
			next_money_card4 <= money_card4;
			next_money_card5 <= money_card5;
			if(take_money == 1) begin
				next_count_second1 <= 0;
			    next_state <= keep_transc_not;
			end
			else begin
				next_money_card1 <= money_card1;
				next_money_card2 <= money_card2;
				next_money_card3 <= money_card3;
				next_money_card4 <= money_card4;
				next_money_card5 <= money_card5;
				if(count_second1 > 0) begin
					next_count_second1 <= count_second1 - 1;
					next_state <= count_down_money;
				end
				else if(count_second1 == 0 && id_card1 == 1 ) begin // count_second1 = 0 ( didn't take money
					next_count_second1 <= 0;
					next_money_card1 <= money_card1 + temp_money;
					next_state <= keep_transc_not;
				end
				else if(count_second1 == 0 && id_card1 == 2 ) begin 
					next_count_second1 <= 0;
					next_money_card2 <= money_card2 + temp_money;
					next_state <= keep_transc_not;
				end
				else if(count_second1 == 0 && id_card1 == 3 ) begin 
					next_count_second1 <= 0;
					next_money_card3 <= money_card3 + temp_money;
					next_state <= keep_transc_not;
				end
				else if(count_second1 == 0 && id_card1 == 4 ) begin 
					next_count_second1 <= 0;
					next_money_card4 <= money_card4 + temp_money;
					next_state <= keep_transc_not;
				end
				else if(count_second1 == 0 && id_card1 == 5 ) begin 
					next_count_second1 <= 0;
					next_money_card5 <= money_card5 + temp_money;
					next_state <= keep_transc_not;
				end
				else begin
					next_count_second1 <= count_second1;
					next_state <= count_down_money;
				end
			end
		end
		trans_money:begin
			next_count_second1 <= count_second1;
			next_count_second2 <= count_second2;
			next_money_card1 <= money_card1;
			next_money_card2 <= money_card2;
			next_money_card3 <= money_card3;
			next_money_card4 <= money_card4;
			next_money_card5 <= money_card5;
			if(id_card2 == 1) begin
				next_money_card1 <= money_card1 + temp_money;
				next_state <= keep_transc_not;
			end
			else if(id_card2 == 2) begin
				next_money_card2 <= money_card2 + temp_money;
				next_state <= keep_transc_not;
			end
			else if(id_card2 == 3) begin
				next_money_card3 <= money_card3 + temp_money;
				next_state <= keep_transc_not;
			end
			else if(id_card2 == 4) begin
				next_money_card4 <= money_card4 + temp_money;
				next_state <= keep_transc_not;
			end
			else if(id_card2 == 5) begin
				next_money_card5 <= money_card5 + temp_money;
				next_state <= keep_transc_not;
			end
			else begin
				next_state <= trans_money;
			end
		end
		keep_transc_not:begin
			next_count_second1 <= count_second1;
			next_count_second2 <= count_second2;
			next_money_card1 <= money_card1;
			next_money_card2 <= money_card2;
			next_money_card3 <= money_card3;
			next_money_card4 <= money_card4;
			next_money_card5 <= money_card5;
			if(key_yes) begin
				next_temp_money <= 0;
				next_which_place <= 0;
				next_digit <= 0;
				next_count_second1 <= 30;
				next_count_second2 <= 10;
				next_flag <= 0;
				next_state <= chose_item;
			end
			else if(key_no) begin
				next_temp_money <= 0;
				next_which_place <= 0;
				next_digit <= 0;
				next_count_second1 <= 30;
				next_count_second2 <= 10;
				next_flag <= 0;
				next_state <= count_down_card;
			end
			else begin
				next_temp_money <= 0;
				next_which_place <= 0;
				next_digit <= 0;
				next_count_second1 <= 30;
				next_count_second2 <= 10;
				next_flag <= 0;
				next_state <= keep_transc_not;
			end
		end
		count_down_card: begin // thank
			next_count_second1 <= count_second1;
			next_count_second2 <= count_second2;
			next_money_card1 <= money_card1;
			next_money_card2 <= money_card2;
			next_money_card3 <= money_card3;
			next_money_card4 <= money_card4;
			next_money_card5 <= money_card5;
			if(card_1 ==0 && card_2 ==0 && card_3 ==0 && card_4 ==0 && card_5 ==0) begin
                next_count_second2 <= 0;
                next_state <= insert_card;  
            end
			else begin
				if(count_second2 > 0) begin
					next_count_second2 <= count_second2 - 1;
					next_state <= count_down_card;
				end
				else begin
					next_count_second2 <= 0;
					next_state <= insert_card;
				end
			end
		end
	endcase
end


endmodule
