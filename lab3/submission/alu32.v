// Author: 0710028 陳敬諺, 0710001 林煜睿

module alu32(
           //rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
		       //bonus_control, // 3 bits bonus control input(input) 
           ALU_op,
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


//input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
input   [2:0]   ALU_op;
//input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

//reg    [32-1:0] result_out;
//reg             zero;
//reg             cout;
//reg             overflow;

wire   [32-1:0] less,carry,eq;
wire            set;
wire            equal;

reg             real_set;

assign less[31:1] = 0;
//assign equal = &eq;

genvar gv_i;

assign zero = ~(|result);

alu_TOP0 alu0(
               src1[0],       //1 bit source 1 (input)
               src2[0],       //1 bit source 2 (input)
               real_set,       //1 bit less     (input)
               equal,
               ALU_control[3],   //1 bit A_invert (input)
               ALU_control[2],   //1 bit B_invert (input)
               ALU_control[2],        //1 bit carry in (input)
               ALU_control[1:0],  //operation      (input)
               //bonus_control[2:0],
               result[0],     //1 bit result   (output)
               carry[1],
               eq[0]  
    );

generate
  for(gv_i = 1 ; gv_i < 31 ; gv_i = gv_i + 1)
  begin : label
      alu_top alun(
               src1[gv_i],       //1 bit source 1 (input)
               src2[gv_i],       //1 bit source 2 (input)
               less[gv_i],       //1 bit less     (input)
               ALU_control[3],   //1 bit A_invert (input)
               ALU_control[2],   //1 bit B_invert (input)
               carry[gv_i],        //1 bit carry in (input)
               ALU_control[1:0],  //operation      (input)
               //bonus_control[2:0],
               result[gv_i],     //1 bit result   (output)
               carry[gv_i+1],
               eq[gv_i]
               );  
  end
endgenerate

alu_buttom alu_31(
               src1[31],       //1 bit source 1 (input)
               src2[31],       //1 bit source 2 (input)
               less[31],       //1 bit less     (input)
               ALU_control[3],   //1 bit A_invert (input)
               ALU_control[2],   //1 bit B_invert (input)
               carry[31],        //1 bit carry in (input)
               ALU_control[1:0],  //operation      (input)
               //bonus_control[2:0],
               result[31],     //1 bit result   (output)
               cout,
               overflow,
               set,
               eq[31]
               );

always @(*) begin
  case(ALU_op)
    3'b111 : real_set = 1'b0 ^ 1'b1 ^ cout;
    default: real_set = set;
  endcase
end

endmodule
