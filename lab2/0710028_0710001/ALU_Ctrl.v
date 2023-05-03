// Author: 0710028 陳敬諺, 0710001 林煜睿

module ALU_Ctrl(
        funct_i,
        ALUOp_i,
        ALUCtrl_o
        );

//I/O ports
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;

//Internal Signals
reg        [4-1:0] ALUCtrl_in_o;

//Select exact operation

assign ALUCtrl_o = ALUCtrl_in_o;

always @(*) begin
	if(ALUOp_i == 3'b100) begin
		case(funct_i)
			6'b100001 : ALUCtrl_in_o <= 4'b0010;
			6'b100011 : ALUCtrl_in_o <= 4'b0110;
			6'b100100 : ALUCtrl_in_o <= 4'b0000;
			6'b100101 : ALUCtrl_in_o <= 4'b0001;
			6'b101010 : ALUCtrl_in_o <= 4'b0111;
			6'b000011 : ALUCtrl_in_o <= 4'b1001;
			6'b000111 : ALUCtrl_in_o <= 4'b1010;
		endcase
	end
	else begin
		case(ALUOp_i)
			3'b010 : ALUCtrl_in_o <= 4'b0010;
			3'b110 : ALUCtrl_in_o <= 4'b0110;
			3'b000 : ALUCtrl_in_o <= 4'b0000;
			3'b001 : ALUCtrl_in_o <= 4'b0001;
			3'b111 : ALUCtrl_in_o <= 4'b0111;
			3'b101 : ALUCtrl_in_o <= 4'b1000;
		endcase
	end
end

endmodule
