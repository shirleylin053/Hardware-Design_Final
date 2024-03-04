
`define NM1 32'd523 //C_freq
`define NM2 32'd587 //D_freq
`define NM3 32'd659 //E_freq
`define NM4 32'd784 //G_freq
`define NM5 32'd880 //A_freq
`define NM6 32'd1046 //HC_freq
`define NM0 32'd20000 //slience (over freq.)

module Music_after (
	input [7:0] ibeatNum,	
	output reg [31:0] tone
);

always @(*) begin
	case (ibeatNum)		// 1/4 beat
		8'd0 : tone = `NM0;	//3
		8'd1 : tone = `NM6;
		8'd2 : tone = `NM6;
		8'd3 : tone = `NM6;
		8'd4 : tone = `NM6;	//1
		8'd5 : tone = `NM6;
		8'd6 : tone = `NM6;
		8'd7 : tone = `NM6;
		8'd8 : tone = `NM6;	//2
		8'd9 : tone = `NM6;
		8'd10 : tone = `NM6;
		8'd11 : tone = `NM6;
		8'd12 : tone = `NM6;	//6-
		8'd13 : tone = `NM6;
		8'd14 : tone = `NM6;
		8'd15 : tone = `NM6;
		
		8'd16 : tone = `NM5;
		8'd17 : tone = `NM5;
		8'd18 : tone = `NM5;
		8'd19 : tone = `NM5;
		8'd20 : tone = `NM5;
		8'd21 : tone = `NM5;
		8'd22 : tone = `NM5;
		8'd23 : tone = `NM5;
		8'd24 : tone = `NM5;
		8'd25 : tone = `NM5;
		8'd26 : tone = `NM5;
		8'd27 : tone = `NM5;
		8'd28 : tone = `NM5;
		8'd29 : tone = `NM5;
		8'd30 : tone = `NM5;
		8'd31 : tone = `NM5;
		
		8'd32 : tone = `NM4;
		8'd33 : tone = `NM4;
		8'd34 : tone = `NM4;
		8'd35 : tone = `NM4;
		8'd36 : tone = `NM4;
		8'd37 : tone = `NM4;
		8'd38 : tone = `NM4;
		8'd39 : tone = `NM4;
		8'd40 : tone = `NM5;
		8'd41 : tone = `NM5;
		8'd42 : tone = `NM5;
		8'd43 : tone = `NM5;
		8'd44 : tone = `NM4;
		8'd45 : tone = `NM4;
		8'd46 : tone = `NM4;
		8'd47 : tone = `NM4;
		
		8'd48 : tone = `NM2;
		8'd49 : tone = `NM2;
		8'd50 : tone = `NM2;
		8'd51 : tone = `NM2;
		8'd52 : tone = `NM3;
		8'd53 : tone = `NM3;
		8'd54 : tone = `NM2;
		8'd55 : tone = `NM2;
		8'd56 : tone = `NM1;
		8'd57 : tone = `NM1;
		8'd58 : tone = `NM1;
		8'd59 : tone = `NM1;
		8'd60 : tone = `NM1;
		8'd61 : tone = `NM1;
		8'd62 : tone = `NM1;
		8'd63 : tone = `NM1;
		default : tone = `NM0;
	endcase
end

endmodule
		
		
		
		