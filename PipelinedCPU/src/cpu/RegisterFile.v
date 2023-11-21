module RegisterFile(
	input wire clk,
	input wire [4:0] in1,
	input wire [4:0] in2,
	input wire [4:0] in3,
	output wire [31:0] rd1,
	output wire [31:0] rd2,
	input wire write,
	input wire [31:0] writeData
   );
	reg [31:0] rgFile[1:31];
	
	always @(negedge clk) 
	begin
		if (write && in3 != 0) 
		begin
			rgFile[in3] <= writeData;
		end
	end

	Mux2to1_reg RegMx1(in1,0,rgFile[in1],rd1);
	Mux2to1_reg RegMx2(in2,0,rgFile[in2],rd2);

endmodule
