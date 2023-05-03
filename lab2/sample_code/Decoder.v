// Author: 0710028 陳敬諺, 0710001 林煜睿

module Decoder(
    instr_op_i,
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    Branch_o
    );

//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;

//Internal Signals
reg    [3-1:0] ALU_op_in_o;
reg            ALUSrc_in_o;
reg            RegWrite_in_o;
reg            RegDst_in_o;
reg            Branch_in_o;

assign RegWrite_o = RegWrite_in_o;
assign ALU_op_o = ALU_op_in_o;
assign ALUSrc_o = ALUSrc_in_o;
assign RegDst_o = RegDst_in_o;
assign Branch_o = Branch_in_o;

always @(*) begin
	case(instr_op_i)
		6'b000000 : {RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o} = {1'b1,1'b0,3'b100,1'b1,1'b0};
		6'b001000 : {RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o} = {1'b1,1'b1,3'b010,1'b0,1'b0};
		6'b001011 : {RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o} = {1'b1,1'b1,3'b111,1'b0,1'b0};
		6'b000100 : {RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o} = {1'b0,1'b0,3'b110,1'b0,1'b1};
		6'b001111 : {RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o} = {1'b1,1'b1,3'b101,1'b0,1'b0};
		6'b001101 : {RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o} = {1'b1,1'b1,3'b001,1'b0,1'b0};
		6'b000101 :	{RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o} = {1'b0,1'b0,3'b110,1'b0,1'b1};	
	endcase
end

endmodule
