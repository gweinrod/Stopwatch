`timescale 1ns/1ns

module swtb();

reg down_sw;
reg adj_sw;
reg adj_sw_b;
reg [1:0] sel_sw;

wire inc_btn;
wire dec_btn;
wire rst_btn;
wire pause_btn;

reg clock;

stopwatch UUT(	.clk(clock), 
					.down_sw(down_sw), 
					.adj_sw(adj_sw), 
					.adj_sw_b(adj_sw_b), 
					.sel_sw(sel_sw), 
					.inc_btn(inc_btn), 
					.dec_btn(dec_btn), 
					.rst_btn(rst_btn), 
					.pause_btn(pause_btn) );

always@* begin
	#5 clock <= ~clock;
end

initial begin
		assign inc_btn = 0;
		assign dec_btn = 0;
		assign res_btn = 0;
		assign pause_btn = 0;
		down_sw = 0;
		adj_sw = 0;
		adj_sw_b = 0;
		sel_sw = 0;
		clock = 0;
		
		//unpause
		#1000  assign pause_btn = 1;
		#10000 assign pause_btn = 0;

		#100000 $finish;
end

endmodule
