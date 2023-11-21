module ID_EX( //Huge...
    input clk,reset,
    input wire regWrite_ID,
    input wire enable_MEM_ID,
    input wire regRead_ID,
    input wire memToReg_ID,
    input wire memWrite_ID,
    input wire [3:0] ALUCtrl_ID,
    input wire [1:0] ALUSrc1_ID,
    input wire [1:0] ALUSrc2_ID,
    input wire [1:0] regDest_ID,
    input wire [31:0] regA_Frwd,
    input wire [31:0] regB_Frwd,
    input wire [31:0] ImmExt_ID,
    input wire [31:0] ShamtExt_ID,
    input wire [31:0] instr_ID,
    input wire [1:0] Frwd1_ID,
    input wire [1:0] Frwd2_ID,
    input wire Frwrd3_ID,
    input wire [31:0] pcPlus4_ID,

    output reg regWrite_EX,
    output reg regRead_EX,
    output reg memToReg_EX,
    output reg memWrite_EX,
    output reg enable_MEM_EX,
    output reg [3:0] ALUCrl_EX,
    output reg [1:0] ALUSrc1_EX,
	output reg [1:0] ALUSrc2_EX,
    output reg [1:0] regDest_EX,
    output reg [31:0] regA_EX,
    output reg [31:0] regB_EX,
    output reg [31:0] ImmExt_EX,
    output reg [31:0] ShamtExt_EX,
    output reg [4:0] Rt_EX,
    output reg [4:0] Rd_EX,
    output reg [1:0] Frwd1_EX,
    output reg [1:0] Frwd2_EX,
    output reg Frwrd3_EX,
    output reg [31:0] pcPlus4_EX

    
);

	always @(posedge clk) begin	// regs between ID and EXE
		if (reset) begin
			regWrite_EX <= 0;
			regRead_EX <= 0;
			memToReg_EX <= 0;
			memWrite_EX <= 0;
			enable_MEM_EX <= 0;
			ALUCrl_EX <= 0;
			ALUSrc1_EX <= 0;
			ALUSrc2_EX <= 0;
			regDest_EX <= 0;
			regA_EX <= 0;
			regB_EX <= 0;
			ImmExt_EX <= 0;
			Rd_EX <= 0;
			Frwd1_EX <= 0;
			Frwd2_EX <= 0;
			Frwrd3_EX <= 0;
			ShamtExt_EX <= 0;
			Rt_EX <= 0;
			pcPlus4_EX <= 0;
		end
		else begin
			regWrite_EX <= regWrite_ID;
			regRead_EX <= enable_MEM_ID;
			memToReg_EX <= regRead_ID;
			memWrite_EX <= memToReg_ID;
			enable_MEM_EX <= memWrite_ID;
			ALUCrl_EX <= ALUCtrl_ID;
			ALUSrc2_EX <= ALUSrc2_ID;
			regB_EX <= regB_Frwd;
			ImmExt_EX <= ImmExt_ID;
			ALUSrc1_EX <= ALUSrc1_ID;
			regDest_EX <= regDest_ID;
			regA_EX <= regA_Frwd;
			ShamtExt_EX <= ShamtExt_ID;
			Rt_EX <= instr_ID[20:16];
			Rd_EX <= instr_ID[15:11];
			Frwd1_EX <= Frwd1_ID;
			Frwd2_EX <= Frwd2_ID;
			Frwrd3_EX <= Frwrd3_ID;
			pcPlus4_EX <= pcPlus4_ID;
		end
	end

endmodule