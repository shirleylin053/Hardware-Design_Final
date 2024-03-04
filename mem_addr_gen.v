module mem_addr_gen(
   input clk,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   output [16:0] pixel_addr
   );
    
  
   assign pixel_addr = ((h_cnt+180)+200*(v_cnt+25))% 18000;  //200*90

    
endmodule

module mem_addr_gen_b(  // poorol
   input clk,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   output [16:0] pixel_addr
   );
  
   assign pixel_addr = ((h_cnt+45)+80*(v_cnt+70))% 6400;  //80*80

    
endmodule


module mem_addr_gen_e(  // password
   input clk,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   output [16:0] pixel_addr
   );
    
  
   assign pixel_addr = ((h_cnt+75)+80*(v_cnt+60))% 6400; // 80*80

    
endmodule


module mem_addr_gen_g(
   input clk,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   output [16:0] pixel_addr
   );
    
  
   assign pixel_addr = ((h_cnt+205)+210*(v_cnt+30))% 8400;  //210*40

    
endmodule