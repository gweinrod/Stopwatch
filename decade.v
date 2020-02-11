module decade(clk, rst, max, down, carry_out, value);

input clk;
input rst;
input [3:0] max;
input down;

output reg [3:0] value;
output reg carry_out;

wire value_inc;
wire value_dec;
assign value_inc = value + 1;
assign value_dec = value - 1;

initial begin
	value <= 0;
	carry_out <= 0;
end

always@(posedge clk) begin
	if (rst) begin
		value <= 0;
		carry_out <=0;
	end
	else begin 
		if ( ~ down) begin
			if (value_inc == max + 1) begin
				carry_out <= 1;
				value <= 0;
			end
			else begin
				carry_out <= 0;
				value <= value_inc;
			end
		end
		else if ( down ) begin
			if (value == 0) begin
				carry_out <= 1;
				value <= max;
			end
			else begin
				carry_out <= 0;
				value <= value_dec;
			end
		end
	end
end

endmodule
