// Author: 0710028 陳敬諺, 0710001 林煜睿

module Decoder(
    instr_op_i,
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    Branch_o,
    Mem_Read_o,
    Mem_Write_o,
    MemToReg_o,
    Jump_o,
    call_ra_o
    );

//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output		   Mem_Read_o;
output         Mem_Write_o;
output [2-1:0] MemToReg_o;
output         Jump_o;
output 		   call_ra_o;

//Internal Signals
reg    [3-1:0] ALU_op_in_o;
reg            ALUSrc_in_o;
reg            RegWrite_in_o;
reg            RegDst_in_o;
reg            Branch_in_o;
reg   		   Mem_Read_in_o;
reg            Mem_Write_in_o;
reg    [2-1:0] MemToReg_in_o;
reg            Jump_in_o;
reg            call_ra_in_o;

assign RegWrite_o = RegWrite_in_o;
assign ALU_op_o = ALU_op_in_o;
assign ALUSrc_o = ALUSrc_in_o;
assign RegDst_o = RegDst_in_o;
assign Branch_o = Branch_in_o;
assign Mem_Read_o = Mem_Read_in_o;
assign Mem_Write_o = Mem_Write_in_o;
assign MemToReg_o = MemToReg_in_o;
assign Jump_o = Jump_in_o;
assign call_ra_o = call_ra_in_o;

localparam [6-1:0] R_TY = 6'b000000, ADDI = 6'b001000, SLTIU = 6'b001011, BEQ = 6'b000100, LUI = 6'b001111, ORI = 6'b001101, BNE = 6'b000101,
				   LW = 6'b100011, SW = 6'b101011, BLEZ = 6'b000110, BGTZ = 6'b000111,
				   JUMP = 6'b000010, JAL = 6'b000011;

always @(*) begin
	case(instr_op_i)
		R_TY  : {RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o,Mem_Read_in_o,Mem_Write_in_o,MemToReg_in_o,Jump_in_o,call_ra_in_o} = {1'b1,1'b0,3'b100,1'b1,1'b0,1'b0,1'b0,2'b00,1'b1,1'b0};
		ADDI  : {RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o,Mem_Read_in_o,Mem_Write_in_o,MemToReg_in_o,Jump_in_o,call_ra_in_o} = {1'b1,1'b1,3'b010,1'b0,1'b0,1'b0,1'b0,2'b00,1'b1,1'b0};
		SLTIU : {RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o,Mem_Read_in_o,Mem_Write_in_o,MemToReg_in_o,Jump_in_o,call_ra_in_o} = {1'b1,1'b1,3'b111,1'b0,1'b0,1'b0,1'b0,2'b00,1'b1,1'b0};
		BEQ   : {RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o,Mem_Read_in_o,Mem_Write_in_o,MemToReg_in_o,Jump_in_o,call_ra_in_o} = {1'b0,1'b0,3'b110,1'b0,1'b1,1'b0,1'b0,2'b00,1'b1,1'b0};
		LUI   : {RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o,Mem_Read_in_o,Mem_Write_in_o,MemToReg_in_o,Jump_in_o,call_ra_in_o} = {1'b1,1'b1,3'b101,1'b0,1'b0,1'b0,1'b0,2'b00,1'b1,1'b0};
		ORI   : {RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o,Mem_Read_in_o,Mem_Write_in_o,MemToReg_in_o,Jump_in_o,call_ra_in_o} = {1'b1,1'b1,3'b001,1'b0,1'b0,1'b0,1'b0,2'b00,1'b1,1'b0};
		BNE   :	{RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o,Mem_Read_in_o,Mem_Write_in_o,MemToReg_in_o,Jump_in_o,call_ra_in_o} = {1'b0,1'b0,3'b110,1'b0,1'b1,1'b0,1'b0,2'b00,1'b1,1'b0};
		LW    :	{RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o,Mem_Read_in_o,Mem_Write_in_o,MemToReg_in_o,Jump_in_o,call_ra_in_o} = {1'b1,1'b1,3'b010,1'b0,1'b0,1'b1,1'b0,2'b01,1'b1,1'b0};	
		SW    :	{RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o,Mem_Read_in_o,Mem_Write_in_o,MemToReg_in_o,Jump_in_o,call_ra_in_o} = {1'b0,1'b1,3'b010,1'b0,1'b0,1'b0,1'b1,2'b00,1'b1,1'b0};	
		BLEZ  :	{RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o,Mem_Read_in_o,Mem_Write_in_o,MemToReg_in_o,Jump_in_o,call_ra_in_o} = {1'b0,1'b0,3'b110,1'b0,1'b1,1'b0,1'b0,2'b00,1'b1,1'b0};	
		BGTZ  :	{RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o,Mem_Read_in_o,Mem_Write_in_o,MemToReg_in_o,Jump_in_o,call_ra_in_o} = {1'b0,1'b0,3'b110,1'b0,1'b1,1'b0,1'b0,2'b00,1'b1,1'b0};	
		JUMP  :	{RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o,Mem_Read_in_o,Mem_Write_in_o,MemToReg_in_o,Jump_in_o,call_ra_in_o} = {1'b0,1'b0,3'b110,1'b0,1'b1,1'b0,1'b0,2'b00,1'b0,1'b0};	//*
		JAL   :	{RegWrite_in_o,ALUSrc_in_o,ALU_op_in_o,RegDst_in_o,Branch_in_o,Mem_Read_in_o,Mem_Write_in_o,MemToReg_in_o,Jump_in_o,call_ra_in_o} = {1'b1,1'b0,3'b110,1'b0,1'b1,1'b0,1'b0,2'b10,1'b0,1'b1};	//*
	endcase
end

endmodule
