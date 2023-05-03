// Author: 0710028 陳敬諺, 0710001 林煜睿

module Simple_Single_CPU(
    clk_i,
    rst_i
    );

// Input port
input clk_i;
input rst_i;

wire [31:0] pc_in_i,pc_temp1,se_ls_2,pc_temp2,pc_jr_sure,pc_be_check;
wire [31:0] pc_to_instr;
wire [27:0] pc_jump_pre;
wire [31:0] instructions;
wire [4:0]  wr_reg;

wire regdst,regwri,alusrc,br,call_reg_ra;
wire [2:0]  aluop;
wire [31:0] wr_data,wr_data_pre;

wire [31:0] rs_to_alu,rt_to_alu;
wire [5:0]  aluctrl;

wire [31:0] signex;
wire [31:0] alu_data2;

wire [31:0] alu_result;
wire [31:0] shift_result;
wire [31:0] mult_result;
wire [31:0] mem_result;

wire memre,memwr;
wire [1:0]  mem_to_reg;

wire zero,z_re,LorE_re,less_re;

wire pointer,jump;

ProgramCounter PC(
    .clk_i(clk_i),
    .rst_i (rst_i),
    .pc_in_i(pc_in_i),
    .pc_out_o(pc_to_instr)
    );

Adder Adder1(
    .src1_i(pc_to_instr),
    .src2_i(32'd4),
    .sum_o(pc_temp1)
    );

Instruction_Memory IM(
    .addr_i(pc_to_instr),
    .instr_o(instructions)
    );

MUX_3to1 #(.size(5)) Mux_Write_Reg(
    .data0_i(instructions[20:16]),
    .data1_i(instructions[15:11]),
    .data2_i(5'b11111),
    .select_i({call_reg_ra,regdst}),
    .data_o(wr_reg)
    );

Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i) ,
    .RSaddr_i(instructions[25:21]) ,
    .RTaddr_i(instructions[20:16]) ,
    .RDaddr_i(wr_reg) ,
    .RDdata_i(wr_data)  ,
    .RegWrite_i (regwri),
    .RSdata_o(rs_to_alu) ,
    .RTdata_o(rt_to_alu)
    );

Decoder Decoder(
    .instr_op_i(instructions[31:26]),
    .RegWrite_o(regwri),
    .ALU_op_o(aluop),
    .ALUSrc_o(alusrc),
    .RegDst_o(regdst),
    .Branch_o(br),
    .Mem_Read_o(memre),
    .Mem_Write_o(memwr),
    .MemToReg_o(mem_to_reg),
    .Jump_o(jump),
    .call_ra_o(call_reg_ra)
    );

ALU_Ctrl AC(
    .funct_i(instructions[5:0]),
    .ALUOp_i(aluop),
    .ALUCtrl_o(aluctrl)
    );

Sign_Extend SE(
    .data_i(instructions[15:0]),
    .alu_op(aluop),
    .data_o(signex)
    );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
    .data0_i(rt_to_alu),
    .data1_i(signex),
    .select_i(alusrc),
    .data_o(alu_data2)
    );

ALU ALU(
    .src1_i(rs_to_alu),
    .src2_i(alu_data2),
    .ctrl_i(aluctrl[3:0]),
    .alu_op(aluop),
    .result_o(alu_result),
    .zero_o(zero)
    );

Multipler mult(
    .scr1(rs_to_alu),
    .scr2(rt_to_alu),
    .mult_ctrl(aluctrl[4]),
    .mult_result(mult_result)
    );

Shifter shifter32(
    .src_1(rs_to_alu),
    .src_2(rt_to_alu),
    .src_signex(signex),
    .shamt(instructions[10:6]),
    .shift_crtl(aluctrl[3:0]),
    .s_result(shift_result)
    );

Shift_Left_Two_32 Shifter_l_2(
    .data_i(signex),
    .data_o(se_ls_2)
    );

Adder Adder2(
    .src1_i(pc_temp1),
    .src2_i(se_ls_2),
    .sum_o(pc_temp2)
    );

Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(alu_result),
    .data_i(rt_to_alu),
    .MemRead_i(memre),
    .MemWrite_i(memwr),
    .data_o(mem_result)
    );

MUX_2to1 #(.size(1)) equal_confirm(
    .data0_i(zero),
    .data1_i(~zero),
    .select_i(instructions[26]),
    .data_o(z_re)
    );

MUX_2to1 #(.size(1)) blez_vs_bgtz(
    .data0_i((alu_result[31]|zero)),
    .data1_i(~(alu_result[31]|zero)),
    .select_i(instructions[26]),
    .data_o(less_re)
    );

MUX_2to1 #(.size(1)) branch_type(
    .data0_i(z_re),
    .data1_i(less_re),
    .select_i(instructions[27]),
    .data_o(LorE_re)
    );

//pointer
assign pointer = br & LorE_re;

Shift_Left_Two_28 Shifter_jump_addr(
    .data_i({2'b00,instructions[25:0]}),
    .data_o(pc_jump_pre)
    );

MUX_2to1 #(.size(32)) Mux_PC_Source_pre(
    .data0_i(pc_temp1),
    .data1_i(rs_to_alu),
    .select_i(aluctrl[5]),
    .data_o(pc_jr_sure)
    );

MUX_2to1 #(.size(32)) Mux_PC_Source(
    .data0_i(pc_jr_sure),
    .data1_i(pc_temp2),
    .select_i(pointer),
    .data_o(pc_be_check)
    );

MUX_2to1 #(.size(32)) Mux_Jump_confirm(
    .data0_i({pc_temp1[31:28],pc_jump_pre}),
    .data1_i(pc_be_check),
    .select_i(jump),
    .data_o(pc_in_i)
    );

MUX_3to1 #(.size(32)) alu_confirm(
    .data0_i(alu_result),
    .data1_i(shift_result),
    .data2_i(mult_result),
    .select_i(aluctrl[4:3]),
    .data_o(wr_data_pre)
    );

MUX_3to1 #(.size(32)) result_confirm(
    .data0_i(wr_data_pre),
    .data1_i(mem_result),
    .data2_i(pc_temp1),
    .select_i(mem_to_reg),
    .data_o(wr_data)
    );

endmodule
