// Author: 0710028 陳敬諺, 0710001 林煜睿

module ALU_Ctrl(
        funct_i,
        ALUOp_i,
        ALUCtrl_o
        );

//I/O ports
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [6-1:0] ALUCtrl_o;

//Internal Signals
reg        [6-1:0] ALUCtrl_in_o;

//Select exact operation

assign ALUCtrl_o = ALUCtrl_in_o;

localparam [6-1:0] ADDU = 6'b100001, SUBU = 6'b100011, AND = 6'b100100, 
				   OR = 6'b100101, SLT = 6'b101010, SRA = 6'b000011, 
				   SRAV = 6'b000111, SLL = 6'b000000, MUL = 6'b011000, JR = 6'b001000;

localparam [3-1:0] ADDI = 3'b010, BNE = 3'b110, NOPE = 3'b000, ORI = 3'b001, SLTIU = 3'b111, LUI = 3'b101;

always @(*) begin
	if(ALUOp_i == 3'b100) begin
		case(funct_i)
			ADDU : ALUCtrl_in_o <= 6'b000010;
			SUBU : ALUCtrl_in_o <= 6'b000110;
			AND  : ALUCtrl_in_o <= 6'b000000;
			OR   : ALUCtrl_in_o <= 6'b000001;
			SLT  : ALUCtrl_in_o <= 6'b000111;
			SRA  : ALUCtrl_in_o <= 6'b001001;
			SRAV : ALUCtrl_in_o <= 6'b001010;
			SLL  : ALUCtrl_in_o <= 6'b001011;
			MUL  : ALUCtrl_in_o <= 6'b010000;
			JR   : ALUCtrl_in_o <= 6'b100000;
		endcase
	end
	else begin
		case(ALUOp_i)
			ADDI  : ALUCtrl_in_o <= 5'b00010;
			BNE   : ALUCtrl_in_o <= 5'b00110;
			NOPE  : ALUCtrl_in_o <= 5'b00000;
			ORI   : ALUCtrl_in_o <= 5'b00001;
			SLTIU : ALUCtrl_in_o <= 5'b00111;
			LUI   : ALUCtrl_in_o <= 5'b01000;
		endcase
	end
end

endmodule
