//
//
//
//

module PlayerCtrl (
	input clk,
	input reset,
	output reg [7:0] ibeat
);
parameter BEATLEAGTH = 63;

always @(posedge clk) begin
	if (reset == 1)
		ibeat <= 0;
	else if (ibeat < BEATLEAGTH) 
		ibeat <= ibeat + 1;
	else 
		ibeat <= 0;
end

endmodule