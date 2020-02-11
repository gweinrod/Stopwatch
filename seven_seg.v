module seven_seg (/*AUTOARG*/
	output reg [3:0] Anode_Activate, // anode signals of the 7-segment LED display
	output reg [6:0] LED_out,// cathode patterns of the 7-segment LED
	input clock, 
	input reset, 
	input wire [3:0] sec_0
	input wire [3:0] sec_1
	input wire [3:0] min_0
	input wire [3:0] min_1
	);

	function [7:0] num_to_7seg;
		input [3:0] din;
		begin
			case (din)
			4'b0000: num_to_7seg = 7'b0000001; // 0
			4'b0001: num_to_7seg = 7'b1001111; // 1
			4'b0010: num_to_7seg = 7'b0010010; // 2
			4'b0011: num_to_7seg = 7'b0000110; // 3
			4'b0100: num_to_7seg = 7'b1001100; // 4
			4'b0101: num_to_7seg = 7'b0100100; // 5
			4'b0110: num_to_7seg = 7'b0100000; // 6
			4'b0111: num_to_7seg = 7'b0001111; // 7
			4'b1000: num_to_7seg = 7'b0000000; // 8
			4'b1001: num_to_7seg = 7'b0000100; // 9
			endcase // case (char)
		end
	endfunction 
	wire [1:0] LED_activating_counter; 
	reg [19:0] refresh_counter; 

	reg [1:0] state;

	always@(clock) begin
		state = state + 1
		
	always @(posedge clock or posedge reset)
		begin 
		if(reset==1)
			refresh_counter <= 0;
		else
			refresh_counter <= refresh_counter + 1;
		end 
	assign LED_activating_counter = refresh_counter[19:18];

always @(clock)
    begin
        case(state)
        2'b00: begin
            Anode_Activate = 4'b0111; 
            LED_BCD = min_1
              end
        2'b01: begin
            Anode_Activate = 4'b1011; 
            LED_BCD = min_0;
              end
        2'b10: begin
            Anode_Activate = 4'b1101; 
            LED_BCD = sec_1;
                end
        2'b11: begin
            Anode_Activate = 4'b1110; 
            LED_BCD = sec_0;
               end
        endcase
    end

	always @(*)
	begin
		LED_out = num_to_7seg(LED_BCD)
	end
endmodule