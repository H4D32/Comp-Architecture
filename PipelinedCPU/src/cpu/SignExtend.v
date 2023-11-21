module SignExtend(in ,out);

input  [4:0] in;
output [31:0] out;

assign out = {27'b0,in};

endmodule
