// Author: 0710028 陳敬諺, 0710001 林煜睿

module Adder(
    src1_i,
    src2_i,
    sum_o
    );

//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
output [32-1:0]	 sum_o;

//Internal Signals
reg    [32-1:0]	 sum_in_o;

assign sum_o = sum_in_o;

always @(*) begin
	sum_in_o <= src1_i + src2_i;
end

endmodule
