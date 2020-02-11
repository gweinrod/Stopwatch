module divider(clk_sel, clk_in, rst, clk_en, clk_out);

parameter clk_sel_1hz = 2'b00;
parameter clk_sel_flash = 2'b01;
parameter clk_sel_display = 2'b10;

reg [26:0] count_max;

input [1:0] clk_sel;
input clk_in;  //100MHZ
input rst;
input clk_en;

output reg clk_out;

reg [26:0] count;


//increment wire
wire count_inc;
assign count_inc = count + 1;

initial begin
	count <= 0;
	clk_out <= 0;

	case(clk_sel)
		clk_sel_1hz: 		count_max <=  100000000;  //1hz
		clk_sel_flash: 		count_max <= 50000000;  //2hz
		clk_sel_display: 	count_max <= 200000;  //500hz
		default:		count_max <= 0;
	endcase
end

always@(posedge clk_in) begin
	if (rst) begin
		count  <= 0;
		clk_out <= 0;
	end
	else if (clk_en) begin
		if (count_inc == count_max) begin
			clk_out = 1;
			count = 0;
		end
		else begin
			clk_out = 0;
			count = count_inc;
		end
	end
end

endmodule
