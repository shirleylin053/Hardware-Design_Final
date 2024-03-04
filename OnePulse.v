module onepulse (
	output reg signal_single_pulse,
	input wire signal,
	input wire clk
	);
	
	reg signal_delay;

	always @(posedge clk) begin
		if (signal == 1'b1 & signal_delay == 1'b0)
		  signal_single_pulse <= 1'b1;
		else
		  signal_single_pulse <= 1'b0;

		signal_delay <= signal;
	end
endmodule
