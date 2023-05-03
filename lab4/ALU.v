// Author: 0710028 陳敬諺, 0710001 林煜睿

module ALU(
    src1_i,
    src2_i,
    ctrl_i,
    alu_op,
    result_o,
    zero_o
    );

//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;
input  [2:0]     alu_op;
output [32-1:0]	 result_o;
output           zero_o;

wire             cout,overflow;
//Internal signals


alu32 alu32bit(
	//.rst_n(),         // negative reset            (input)
    .src1(src1_i),          // 32 bits source 1          (input)
    .src2(src2_i),          // 32 bits source 2          (input)
    .ALU_control(ctrl_i),   // 4 bits ALU control input  (input)
	//.bonus_control(), // 3 bits bonus control input(input) 
    .ALU_op(alu_op),
    .result(result_o),        // 32 bits result            (output)
    .zero(zero_o),          // 1 bit when the output is 0, zero must be set (output)
    .cout(cout),          // 1 bit carry out           (output)
    .overflow(overflow)       // 1 bit overflow            (output)
	);

endmodule
