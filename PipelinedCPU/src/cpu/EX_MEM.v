module EX_MEM( 
    input clk,
    input wire regWrite_EX,
    input wire memToReg_EX ,
    input wire memWrite_EX ,
    input wire enable_MEM_EX ,
    input wire [31:0] ALUresult_EX ,
    input wire [4:0] writeReg_EX ,
    input wire regRead_EX ,
    input wire Frwrd3_EX ,
    input wire [31:0] editData_IN,

    output reg regWrite_MEM,
    output reg memToReg_MEM ,
    output reg memWrite_MEM ,
    output reg enable_MEM ,
    output reg [31:0] ALUresult_MEM ,
    output reg [4:0] writeReg_MEM ,
    output reg regRead_MEM ,
    output reg Frwrd3_MEM ,
    output reg [31:0] editData_MEM 
   );
   
	always @(posedge clk) begin	
		regWrite_MEM <= regWrite_EX;
		memToReg_MEM <= memToReg_EX;
		memWrite_MEM <= memWrite_EX;
		enable_MEM <= enable_MEM_EX;
		ALUresult_MEM <= ALUresult_EX;
		writeReg_MEM <= writeReg_EX;
		regRead_MEM <= regRead_EX;
		Frwrd3_MEM <= Frwrd3_EX;
		editData_MEM <= editData_IN ;
	end
endmodule