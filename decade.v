module decade(clk, rst, max, down, carry_out, count);

input clk;
input [3:0] setvalue;
input [3:0] max;
input down;

output reg [3:0] count;
output reg carry_out;

wire count_inc;

if ( down ) assign count_int = count - 1;
else assign count_inc = count + 1;

initial begin
	count <= 0;
	carry_out <= 0;
end

always@(posedge clk) if (rst) begin
	count <= 0;
	carry_out <=0;
end


always@(posedge clk) if ( ~ down && ~ rst) begin
	if (count_inc == max + 1) begin
		carry_out <= 1;
		count <= 0;
	end
	else begin
		carry_out <= 0;
		count <= count_inc;
	end
end

always@(posedge clk) if ( down && ~ rst ) begin
	if (count == 0) begin
		carry_out <= 1;
		count <= max;
	end
	else begin
		carry_out <= 0;
		count <= count_inc;
	end
end


