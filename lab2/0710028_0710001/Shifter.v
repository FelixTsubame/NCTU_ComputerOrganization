// Author: 0710028 陳敬諺, 0710001 林煜睿

module Shifter(
	src_1,
	src_2,
	src_signex,
	shamt,
	shift_crtl,
	s_result
	);

input [31:0] src_2,src_signex;
input [31:0] src_1;
input [4:0]  shamt;
input [3:0]  shift_crtl;
output [31:0] s_result;

wire signed [31:0] src_2;

reg [31:0]   s_in_result;

assign s_result = s_in_result;

always @(*) begin
	case(shift_crtl)
		4'b1000: s_in_result <= src_signex << 16;
		4'b1001: s_in_result <= src_2 >>> shamt;
		4'b1010: s_in_result <= src_2 >>> src_1;
	endcase
end

endmodule