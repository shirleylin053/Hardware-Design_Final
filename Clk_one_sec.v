module CLK_ONE_SEC(clk, clk_one_sec);
input clk;
output clk_one_sec;
reg clk_one_sec;
reg [31:0] count;


always@(posedge clk) 
begin

	if(count==49999999) begin
		clk_one_sec=~clk_one_sec;
		count<=0;
	end
	else if(count>=0 && count<49999999)begin
		count=count+1;
	end
	else begin
		count=0;
		clk_one_sec=0;
	end
	
end

endmodule
