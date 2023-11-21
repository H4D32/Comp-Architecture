module MEM_WB( 
    input clk,

    input wire regWrite_MEM,
    input wire memToReg_MEM,
    input wire [31:0] ALUresult_MEM,
    input wire [31:0] readData_MEM,
    input wire [4:0] writeReg_MEM,

    output reg regWrite_WB,
    output reg memToReg_WB,
    output reg [31:0] ALUresult_WB,
    output reg [31:0] readData_WB,
    output reg [4:0] writeReg_WB
   );

	always @(posedge clk) begin
		regWrite_WB <= regWrite_MEM;
		ALUresult_WB <= ALUresult_MEM;
		readData_WB <= readData_MEM;
		memToReg_WB <= memToReg_MEM;
		writeReg_WB <= writeReg_MEM;
	end

endmodule