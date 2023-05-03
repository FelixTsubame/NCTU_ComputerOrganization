// Author: 0710028 陳敬諺, 0710001 林煜睿

module Sign_Extend(
    data_i,
    alu_op,
    data_o
    );

//I/O ports
input   [16-1:0] data_i;
input   [2:0]    alu_op;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_in_o;

//Sign extended

assign data_o = data_in_o;

always @(*) begin
	case(alu_op)
		3'b001: data_in_o <= {{16{1'b0}},data_i};
		default:data_in_o <= {{16{data_i[15]}},data_i};
	endcase
end

endmodule
