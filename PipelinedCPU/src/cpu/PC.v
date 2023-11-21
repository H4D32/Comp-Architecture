module PCBuffer(
	input wire [31:0] PC_IN,
	output wire [31:0] PC_OUT
   );

    assign PC_OUT = PC_IN;

endmodule

module PCAdder( 
	input wire [31:0] PC_IN,
	output wire [31:0] PC_OUT
   );

    assign PC_OUT = PC_IN + 4;

endmodule