// Author: 0710028 陳敬諺, 0710001 林煜睿

module Multipler(
	scr1,
	scr2,
	mult_ctrl,
	mult_result
);

	input [32-1:0] scr1;
	input [32-1:0] scr2;
	input 		   mult_ctrl;
	output[32-1:0] mult_result;

	reg   [64-1:0] mult_result_reg;

	assign mult_result = mult_result_reg[31:0];

always @(*) begin
	mult_result_reg = scr1 * scr2;
end

endmodule