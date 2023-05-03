// Author: 0710028 陳敬諺, 0710001 林煜睿

module MUX_2to1(
    data0_i,
    data1_i,
    select_i,
    data_o
    );

parameter size = 0;

//I/O ports
input   [size-1:0] data0_i;
input   [size-1:0] data1_i;
input              select_i;
output  [size-1:0] data_o;

//Internal Signals
reg     [size-1:0] data_in_o;

assign data_o = data_in_o;

always @(*) begin
	data_in_o = (select_i) ? data1_i : data0_i;
end

endmodule
