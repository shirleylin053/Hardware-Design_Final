module CreateLargePulse(lg_pls, pls, rst, clk);
    output lg_pls;
    input rst, clk, pls;
    parameter n = 16; 
    reg pulse;
    reg [n:0] count = 0;
  
    always @(posedge clk) begin
        if(rst) begin
            count <= 0;
        end
        else  begin
            if(pls && !pulse) begin
                pulse <= 1'b1;
            end else if(pulse) begin
                if(count[n]) begin
                    count <= 0;
                    pulse <= 1'b0;
                end else
                    count <= count + 1;
            end else
                count <= 0;
        end
    end

    assign lg_pls = (pulse && !count[n]) ? 1'b1: 1'b0;

endmodule
