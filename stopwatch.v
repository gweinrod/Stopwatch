module stopwatch ( clk, rst, down, pause, set, minutes, seconds );

input clk;
input rst;
input down;
input pause;
input set;

output reg [5:0] minutes;
output reg [5:0] seconds;

initial begin
	minutes <= 0;
	seconds <= 0;
end

always@ ( posedge clk or rst ) begin
	if ( rst ) begin
		minutes <= 0;
		seconds <= 0;
	end
	else begin
		if ( ~ down ) begin