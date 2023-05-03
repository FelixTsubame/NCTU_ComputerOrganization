// Author: 0710028 陳敬諺, 0710001 林煜睿

module alu_buttom(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               //com_op,
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               overflow,
               set,
               eq
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;
//input   [2:0] com_op;

output        result;
output        cout;
output        overflow;
output reg    set;
output        eq;

reg           result;

wire          m1,m2,op1,op2,op3,op4;

assign m1 = A_invert ^ src1;
assign m2 = B_invert ^ src2;
assign op1 = m1 & m2;
assign op2 = m1 | m2;
assign op3 = m1 ^ m2 ^ cin;
assign op4 = less;
assign cout = ((m1 ^ m2) & cin) ^ (m1 & m2);
assign overflow = cin ^ cout;
assign eq = m1 ^ m2;

always@( * )
     begin
     case(operation)
          2'b00 : result = op1;
          2'b01 : result = op2;
          2'b10 : result = op3;
          2'b11 : result = op4;
     endcase
     set = op3;

end

endmodule