module stopwatch(clk, rst, paus, down, adj, adj_b, sel, inc_btn, dec_btn);

parameter clk_sel_1hz = 2'b00;
parameter clk_sel_flash = 2'b01;
parameter clk_sel_display = 2'b10;

parameter dig_sel_4 = 2'b11;
parameter dig_sel_3 = 2'b10;
parameter dig_sel_2 = 2'b01;
parameter dig_sel_1 = 2'b00;

parameter min_1_max = 5;
parameter min_0_max = 9;
parameter sec_1_max = 5;
parameter sec_0_max = 9;


input clk;  //from board 100MHZ
input rst;  //user reset button
input pause;  //user pause
input down;  //count down

input [1:0] sel; // user input
input adj;
input adj_b;

input down;

input inc_btn;
input dec_btn;
input pause_btn;
input rst_btn;

reg inc_btn_ff;;  //flip flops for edge detected press
reg dec_btn_ff;
reg rst_btn_ff;
reg pause_btn_ff;

reg paused;

wire goingdown
assign goingdown = down | (adj && adj_b && decrement);

initial begin
	countdown <= down;
end
	

//00 - seconds col 0
//01 - seconds col 1
//10 - minutes col 0
//11 - minutes col 1

//clock for each digit counter
wire clk_en_min_1;
wire clk_en_min_0;
wire clk_en_sec_1;
wire clk_en_sec_0;


//autowire

to carry output of digit counters
wire carry_min_1;  //auto-pause condition

wire carry_min_0;  //rollover
wire carry_sec_1;
wire carry_sec_0;

wire 1hz_clk;  //to clk_out output of clock dividers
wire 2hz_clk;
wire 500_clk;

wire min_1_val; //to values of digit counters
wire min_0_val;
wire sec_1_val;
wire sec_0_val;



assign clk_min_1 	= carry_min_0 	| (adj && adj_b && (sel == dig_sel_4) && (inc | dec));
assign clk_min_0 	= carry_sec_1 	| (adj && adj_b && (sel == dig_sel_3) && (inc | dec));
assign clk_en_sec_1 	= carry_sec_0 	| (adj && adj_b && (sel == dig_sel_2) && (inc | dec));
assign clk_en_sec_0 	= 1hz_clk 	| (adj && adj_b && (sel == dig_sel_1) && (inc | dec));

module divider 1hz(.clk_sel(clk_sel_1hz), 
		   .clk_in(clk),
		   .rst(reset),
		   .clk_en(~paused),
		   .clk_out(1hz_clk));

module decade min_1(.clk(clk_min_1),
		    .rst(reset), 
		    .max(min_1_max), 
		    .down(down),
		    .carry_out(carry_min_1),
		    .count(min_1_val));

module decade min_0(.clk(clk_min_0),
		    .rst(reset), 
		    .max(min_0_max), 
		    .down(down),
		    .carry_out(carry_min_0),
		    .count(min_0_val));
module decade sec_1(.clk(clk_sec_1),
		    .rst(reset), 
		    .max(sec_1_max), 
		    .down(down),
		    .carry_out(carry_sec_1),
		    .count(sec_1_val));
module decade sec_0(.clk(clk_sec_0),
		    .rst(reset), 
		    .max(sec_0_max), 
		    .down(down),
		    .carry_out(carry_sec_0),
		    .count(sec_0_val));



always@(posedge clk) begin
	//counting
	if (decrement) begin
		countdown <= 1;
