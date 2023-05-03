// Author: 0710028 陳敬諺, 0710001 林煜睿

module Shift_Left_Two_28(
    data_i,
    data_o
    );

//I/O ports
input [28-1:0] data_i;
output [28-1:0] data_o;

assign data_o = data_i << 2;

endmodule
