// Author: 0710028 陳敬諺, 0710001 林煜睿

module MUX_3to1(
    data0_i,
    data1_i,
    data2_i,
    select_i,
    data_o
    );

parameter size = 0;

//I/O ports
input   [size-1:0] data0_i;
input   [size-1:0] data1_i;
input   [size-1:0] data2_i;
input   [2-1:0]    select_i;
output  [size-1:0] data_o;

//Internal Signals
reg     [size-1:0] data_in_o;

assign data_o = data_in_o;

always @(*) begin
	case(select_i)
		2'b00 : data_in_o <= data0_i;
		2'b01 : data_in_o <= data1_i;
		2'b10 : data_in_o <= data2_i;
	endcase
end

endmodule
