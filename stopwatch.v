module stopwatch(clk, down_sw, adj_sw, adj_sw_b, sel_sw, inc_btn, dec_btn, rst_btn, pause_btn);

//TODO: definitions.v, includes
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

//switches
input down_sw;  //count down
input [1:0] sel_sw; // user input
input adj_sw;
input adj_sw_b;

//buttons
input inc_btn;
input dec_btn;
input rst_btn;
input pause_btn;

//registers for debouncing
reg [2:0] inc_db;
reg [2:0] dec_db;
reg [2:0] rst_db;
reg [2:0] pause_db;

//flips flops for edge detection
reg inc_btn_ff;
reg dec_btn_ff;
reg rst_btn_ff;
reg pause_btn_ff;

//use state machine instead of paused?
reg paused;

//to every decade module
wire down;
assign down = down_sw || (adj_sw && adj_sw_b && dec_btn_ff);

//clock enable for each digit counter
wire clk_en_min_1;
wire clk_en_min_0;
wire clk_en_sec_1;
wire clk_en_sec_0;

//autowire
//to carry output of digit counters
wire carry_min_1;  //auto-pause condition
wire carry_min_0;  //rollover
wire carry_sec_1;
wire carry_sec_0;

//to clk_out output of clock dividers
wire clk_1hz;
wire clk_2hz;
wire clk_500hz;

//to values of digit counters
wire min_1_val;
wire min_0_val;
wire sec_1_val;
wire sec_0_val;
//end autowire

//clock enable logic
//carry from previous digit/1hz tick, or when incrementing/decrementing
assign clk_en_min_1 	= carry_min_0 	|| 	(adj_sw && adj_sw_b && (sel_sw == dig_sel_4) && (inc_btn_ff || dec_btn_ff));
assign clk_en_min_0 	= carry_sec_1 	|| 	(adj_sw && adj_sw_b && (sel_sw == dig_sel_3) && (inc_btn_ff || dec_btn_ff));
assign clk_en_sec_1 	= carry_sec_0 	|| 	(adj_sw && adj_sw_b && (sel_sw == dig_sel_2) && (inc_btn_ff || dec_btn_ff));
assign clk_en_sec_0 	= clk_1hz		|| 	(adj_sw && adj_sw_b && (sel_sw == dig_sel_1) && (inc_btn_ff || dec_btn_ff));

divider _clk_1hz(.clk_sel(clk_sel_1hz),
		   .clk_in(clk),
		   .rst(rst_btn_ff),
		   .clk_en(~paused),
		   .clk_out(clk_1hz));

divider _clk_2hz(.clk_sel(clk_sel_1hz), 
		   .clk_in(clk),
		   .rst(rst_btn_ff),
		   .clk_en(~paused),
		   .clk_out(clk_2hz));

divider _clk_500hz(.clk_sel(clk_sel_1hz), 
		   .clk_in(clk),
		   .rst(rst_btn_ff),
		   .clk_en(~paused),
		   .clk_out(clk_500hz));

decade min_1(.clk(clk_min_1),
		    .rst(rst_btn_ff), 
		    .max(min_1_max), 
		    .down(down),
		    .carry_out(carry_min_1),
		    .value(min_1_val));
decade min_0(.clk(clk_min_0),
		    .rst(rst_btn_ff), 
		    .max(min_0_max), 
		    .down(down),
		    .carry_out(carry_min_0),
		    .value(min_0_val));
decade sec_1(.clk(clk_sec_1),
		    .rst(rst_btn_ff), 
		    .max(sec_1_max), 
		    .down(down),
		    .carry_out(carry_sec_1),
		    .value(sec_1_val));
decade sec_0(.clk(clk_sec_0),
		    .rst(rst_btn_ff), 
		    .max(sec_0_max), 
		    .down(down),
		    .carry_out(carry_sec_0),
		    .value(sec_0_val));

//module seven segment display
//500hz_clk

task reset_watch;
	begin
	//reset debouncing
	inc_db <= 0;
	dec_db <= 0;
	rst_db <= 0;
	pause_db <= 0;
	//reset button pressed
	inc_btn_ff <= 0;
	dec_btn_ff <= 0;
	rst_btn_ff <= 0;
	pause_btn_ff <= 0;
	//set paused
	paused <= 1;
	end
endtask

//initialize
initial begin
	reset_watch;
end

//read user input
always@(posedge clk) begin
//
//TODO: edge detection for inc, dec, rst, pause buttons
//

//at 500hz, left shift in the value of the board output wire to the 3 bit register

//eg up button
//stepU[2:0]  <= {btnU, stepU[2:1]}
//assign is_btnU_posEdge = ~ stepU[0] & stepU[1];
//look for 0111000?  sample @ 200?

end

//do user input
always@(posedge clk) begin
	//check reset
	if (rst_btn_ff) reset_watch;

	//blink during adjustment
	if (adj_sw) begin
		//TODO: blink selected digit (dig_sel) at 2hz
	end
	
	//increment selected digit 2x, 2x per sec
	if (adj_sw & ~adj_sw_b) begin
		//TODO: scroll 2 sec 2x per sec (count twice at 2 hz)
		//sel_sw
	end
	
	//check pause	
	if (pause_btn_ff) paused <= 1;
	else paused <= 0;
end

endmodule
