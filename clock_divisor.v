module clock_divider(clk1, clk13, clk16, clk22, clk);
input clk;
output clk1;
output clk13;
output clk16;
output clk22;

reg [21:0] num;
wire [21:0] next_num;

always @(posedge clk) begin
  num <= next_num;
end

assign next_num = num + 1'b1;
assign clk1 = num[1];
assign clk13 = num[12];
assign clk16 = num[15];
assign clk22 = num[21];
endmodule
