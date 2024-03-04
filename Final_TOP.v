
module Final_TOP(vgaRed, vgaGreen, vgaBlue, hsync, vsync, led_password_1, led_password_2, led_password_3, led_password_4, led_password_5, led_password_6, state_keyin_pass, state_chose_item, state_keyin_card, state_decide_howmuch, state_put_in, state_trans_money, state_keep_transc_not, state_money_not_enough, state_keyin_wrong, pmod_1, pmod_2, pmod_4, DIGIT, DISPLAY, warning, clk, reset, take_money, card_1, card_2, card_3, card_4, card_5, PS2_CLK, PS2_DATA			
);

inout  PS2_CLK;
inout  PS2_DATA;

output [3:0] DIGIT;
output [6:0] DISPLAY;
output warning;
output state_keyin_pass, state_chose_item, state_keyin_card, state_decide_howmuch, state_put_in, state_trans_money, state_keep_transc_not, state_money_not_enough, state_keyin_wrong;
output led_password_1, led_password_2, led_password_3, led_password_4, led_password_5, led_password_6;

output pmod_1; // music
output pmod_2;
output pmod_4;

output [3:0] vgaRed; // vga
output [3:0] vgaGreen;
output [3:0] vgaBlue;
output hsync;
output vsync;

input clk;
input reset, take_money;
input card_1, card_2, card_3, card_4, card_5;
wire key_0, key_1, key_2, key_3, key_4, key_5, key_6, key_7, key_8, key_9;
wire key_enter, key_correct, key_back;
wire key_a, key_b, key_c, key_d, key_e, key_f;
wire key_yes, key_no;
wire clk_25MHz, clk13, clk16, clk22, clk_1sec;

wire PS2_CLK; 
wire PS2_DATA;

wire [11:0] data; // vga
wire [16:0] pixel_addr, pixel_addr_b, pixel_addr_e, pixel_addr_g;
wire [11:0] pixel, pixel_b, pixel_c, pixel_d, pixel_e, pixel_g, pixel_h, pixel_j, pixel_m;
wire valid;
wire [9:0] h_cnt; //640
wire [9:0] v_cnt;  //480

wire [3:0]state;
wire [2:0]which_place;
wire [3:0] BCD0, BCD1;


wire db_reset;
wire op_reset;
wire l_key_0, l_key_1, l_key_2, l_key_3, l_key_4, l_key_5, l_key_6, l_key_7, l_key_8, l_key_9;
wire l_key_enter, l_key_correct, l_key_back;
wire l_key_a, l_key_b, l_key_c, l_key_d, l_key_e, l_key_f;
wire l_key_yes, l_key_no;

wire  pmod_1_a, pmod_2_a,  pmod_4_a;
wire  pmod_1_b, pmod_2_b,  pmod_4_b;

assign pmod_1 = (music_front_on == 0) ? pmod_1_a : pmod_1_b;  // music
assign pmod_2 = (music_front_on == 0) ? pmod_2_a : pmod_2_b;
assign pmod_4 = ( music_front_on == 0 || music_after_on == 0) ? 1 : 0; 

// vga 640 * 480
assign {vgaRed, vgaGreen, vgaBlue} =  (valid==1'b1 && state == 4'b0000 && h_cnt >=220 && h_cnt<=420 && v_cnt>= 60 && v_cnt<= 150) ? pixel:  // insert_card
									  (valid==1'b1 && state == 4'b0000 && h_cnt >=280 && h_cnt<=360 && v_cnt>= 250&& v_cnt<= 330) ? pixel_b:  // pooral
									  (valid==1'b1 && state == 4'b0001 && h_cnt >=220 && h_cnt<=420 && v_cnt>= 60&& v_cnt<= 150) ? pixel_d:  // keyin_pass
									  
									  (valid==1'b1 && state == 4'b0001 && which_place ==1 && h_cnt >=80 && h_cnt<=160 && v_cnt>= 250&& v_cnt<= 330) ? pixel_e:  // password
									  (valid==1'b1 && state == 4'b0001 && which_place ==2 && h_cnt >=80 && h_cnt<=240 && v_cnt>= 250&& v_cnt<= 330) ? pixel_e:
									  (valid==1'b1 && state == 4'b0001 && which_place ==3 && h_cnt >=80 && h_cnt<=320 && v_cnt>= 250&& v_cnt<= 330) ? pixel_e:
									  (valid==1'b1 && state == 4'b0001 && which_place ==4 && h_cnt >=80 && h_cnt<=400 && v_cnt>= 250&& v_cnt<= 330) ? pixel_e:
									  (valid==1'b1 && state == 4'b0001 && which_place ==5 && h_cnt >=80 && h_cnt<=480 && v_cnt>= 250&& v_cnt<= 330) ? pixel_e:
									  (valid==1'b1 && state == 4'b0001 && which_place ==6 && h_cnt >=80 && h_cnt<=560 && v_cnt>= 250&& v_cnt<= 330) ? pixel_e:
									  
									  (state == 4'b1101 && h_cnt >= 240 && h_cnt <= 400  &&  v_cnt>= 80 && v_cnt<= 100 ) ? 12'hff0:
									  (state == 4'b1101 && h_cnt >= 380 && h_cnt <= 400  &&  v_cnt>= 100 && v_cnt<= 160 ) ? 12'hff0:
									  (state == 4'b1101 && h_cnt >= 240 && h_cnt <= 260  &&  v_cnt>= 100 && v_cnt<= 240 ) ? 12'hff0:
									  (state == 4'b1101 && h_cnt >= 260 && h_cnt <= 400  &&  v_cnt>= 220 && v_cnt<= 240 ) ? 12'hff0:
									  (state == 4'b1101 && h_cnt >= 380 && h_cnt <= 400  &&  v_cnt>= 240 && v_cnt<= 400 ) ? 12'hff0:
									  (state == 4'b1101 && h_cnt >= 240 && h_cnt <= 380  &&  v_cnt>= 380 && v_cnt<= 400 ) ? 12'hff0:
									  (state == 4'b1101 && h_cnt >= 240 && h_cnt <= 260  &&  v_cnt>= 320 && v_cnt<= 380 ) ? 12'hff0:
									  (state == 4'b1101 && h_cnt >= 280 && h_cnt <= 300  &&  v_cnt>= 20 && v_cnt<= 460 ) ? 12'hff0:
									  (state == 4'b1101 && h_cnt >= 340 && h_cnt <= 360  &&  v_cnt>= 20 && v_cnt<= 460 ) ? 12'hff0:
									  
									  (valid==1'b1 && state == 4'b0010 && h_cnt >=215 && h_cnt<=425 && v_cnt>= 250 && v_cnt<= 290) ? pixel_g: // chose_abc
									  
									  (valid==1'b1 && state == 4'b0100 && h_cnt >=215 && h_cnt<=425 && v_cnt>= 250 && v_cnt<= 290) ? pixel_h: // chose_money a~f
									  
									  (valid==1'b1 && state == 4'b0011 && h_cnt >=220 && h_cnt<=420 && v_cnt>= 60 && v_cnt<= 150) ? pixel_j:  // keyin_card 
									  
									  (valid==1'b1 && state == 4'b1001 && h_cnt >=220 && h_cnt<=420 && v_cnt>= 60 && v_cnt<= 150) ? pixel_m: // keep_not
									  
									  (valid==1'b1 && state == 4'b1110 && h_cnt >=220 && h_cnt<=420 && v_cnt>= 60&& v_cnt<= 150) ? pixel_c: // thanks
									  (valid==1'b1 && state == 4'b1110 && h_cnt >=280 && h_cnt<=360 && v_cnt>= 250&& v_cnt<= 330) ? pixel_b: 0; // pooral


ButtonCtrl bt(
 key_0,
 key_1,
 key_2,
 key_3,
 key_4,
 key_5,
 key_6,
 key_7,
 key_8,
 key_9,
 key_enter,
 key_correct,
 key_back,
 key_a,
 key_b,
 key_c,
 key_d,
 key_e,
 key_f,
 key_yes,
 key_no,
 clk,
 reset,
 PS2_DATA,
 PS2_CLK
);


debounce db2(db_reset, reset, clk16);
onepulse op7(op_reset, db_reset, clk16);

CreateLargePulse crnum0(l_key_0, key_0, reset, clk);
CreateLargePulse crnum1(l_key_1, key_1, reset, clk);
CreateLargePulse crnum2(l_key_2, key_2, reset, clk);
CreateLargePulse crnum3(l_key_3, key_3, reset, clk);
CreateLargePulse crnum4(l_key_4, key_4, reset, clk);
CreateLargePulse crnum5(l_key_5, key_5, reset, clk);
CreateLargePulse crnum6(l_key_6, key_6, reset, clk);
CreateLargePulse crnum7(l_key_7, key_7, reset, clk);
CreateLargePulse crnum8(l_key_8, key_8, reset, clk);
CreateLargePulse crnum9(l_key_9, key_9, reset, clk);

CreateLargePulse crop1(l_key_enter, key_enter, reset, clk);
CreateLargePulse crop2(l_key_correct, key_correct, reset, clk);
CreateLargePulse crop3(l_key_back, key_back, reset, clk);

CreateLargePulse crch1(l_key_a, key_a, reset, clk);
CreateLargePulse crch2(l_key_b, key_b, reset, clk);
CreateLargePulse crch3(l_key_c, key_c, reset, clk);
CreateLargePulse crch4(l_key_d, key_d, reset, clk);
CreateLargePulse crch5(l_key_e, key_e, reset, clk);

CreateLargePulse cryes(l_key_yes, key_yes, reset, clk);
CreateLargePulse crno(l_key_no, key_no, reset, clk);


CLK_ONE_SEC kkk(clk, clk_1sec);
clock_divider CD(clk_25MHz, clk13, clk16, clk22, clk);

mem_addr_gen mem_addr_gen_inst( 
    .clk(clk22),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .pixel_addr(pixel_addr)
    );

blk_mem_gen_0 blk_mem_gen_0_inst(  // picture insert_card    200*90
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr),
      .dina(data[11:0]),
      .douta(pixel)
    ); 	

blk_mem_gen_2 blk_mem_gen_0_inst_2(  // picture keyin_pass   200*90
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr),
      .dina(data[11:0]),
      .douta(pixel_d)
    );
blk_mem_gen_3 blk_mem_gen_0_inst_3(  // picture thanks   200*90
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr),
      .dina(data[11:0]),
      .douta(pixel_c)
    );

blk_mem_gen_9 blk_mem_gen_0_inst_9(  // picture key_in card  200*90
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr),
      .dina(data[11:0]),
      .douta(pixel_j)
    );

blk_mem_gen_11 blk_mem_gen_0_inst_11(  // picture keep_not  200*90
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr),
      .dina(data[11:0]),
      .douta(pixel_m)
    );
	
	
	
mem_addr_gen_b mem_addr_gen_inst_b( 
    .clk(clk22),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .pixel_addr(pixel_addr_b)
    );

blk_mem_gen_1 blk_mem_gen_0_inst_1(  // picture poorol   80*80
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_b),
      .dina(data[11:0]),
      .douta(pixel_b)
    );	
	

mem_addr_gen_e mem_addr_gen_inst_e( 
    .clk(clk22),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .pixel_addr(pixel_addr_e)
    );

blk_mem_gen_4 blk_mem_gen_0_inst_4(  // picture password 80*80
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_e),
      .dina(data[11:0]),
      .douta(pixel_e)
    );
	
	
mem_addr_gen_g mem_addr_gen_inst_g( 
    .clk(clk22),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .pixel_addr(pixel_addr_g)
    );	

blk_mem_gen_6 blk_mem_gen_0_inst_6(  // picture chose_item abc  210*40
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_g),
      .dina(data[11:0]),
      .douta(pixel_g)
    );	
blk_mem_gen_7 blk_mem_gen_0_inst_7(  // picture chose_money a~f  210*40
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_g),
      .dina(data[11:0]),
      .douta(pixel_h)
    );	

	
vga_controller   vga_inst(
      .pclk(clk_25MHz),
      .reset(op_reset),
      .hsync(hsync),
      .vsync(vsync),
      .valid(valid),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt)
    );
	
	


ATM_FSM fuck( which_place, state, led_password_1, led_password_2, led_password_3, led_password_4, led_password_5, led_password_6, state_keyin_pass, state_chose_item, state_keyin_card, state_decide_howmuch, state_put_in, state_trans_money, state_keep_transc_not, state_money_not_enough, state_keyin_wrong, BCD1, BCD0, warning, music_front_on, music_after_on, clk_1sec, clk16, op_reset, take_money, card_1, card_2, card_3, card_4, card_5, 
	l_key_0, l_key_1, l_key_2, l_key_3, l_key_4, l_key_5, l_key_6, l_key_7, l_key_8, l_key_9, l_key_enter,
	l_key_correct, l_key_back, l_key_a, l_key_b, l_key_c, l_key_d, l_key_e, l_key_yes, l_key_no
    );
	
Music_TOP_front mu(clk, music_front_on, pmod_1_a, pmod_2_a,  pmod_4_a);
Music_TOP_after mu2(clk, music_after_on, pmod_1_b, pmod_2_b,  pmod_4_b);

LED7SEG SevenSeg(DIGIT, DISPLAY, BCD0, BCD1, clk13);

endmodule