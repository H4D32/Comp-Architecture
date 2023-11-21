`include "alu.v"
`include "ControlUnit.v"
`include "InstructionRAM.v"
`include "MainMemory.v"
`include "RegisterFile.v"
`include "PC.v"
`include "Mux.v"
`include "IF_ID.v"
`include "Comparator.v"
`include "ID_EX.v"
`include "EX_MEM.v"
`include "MEM_WB.v"
`include "SignExtend.v"

module CPU(
	input wire clk,
	input wire reset
   );

	wire [31:0] PC_IF;
	wire enable_IF;
	wire [31:0] pcPlus4_IF;
	wire [31:0] read_instr;
	wire [31:0] pcRead;
	
	wire enable_ID;
	wire reset_ID;
	
	wire [31:0] instr_ID;
	wire [31:0] PC_ID;
	wire [31:0] pcPlus4_ID;
	wire regEqual_flag;
	wire regWrite_ID;
	wire memWrite_ID;
	wire memToReg_ID;
	wire enable_MEM_ID;
	wire [1:0] ALUSrc1_ID;
	wire [1:0] ALUSrc2_ID;	
	wire [1:0] regDest_ID;
	wire [3:0] ALUCtrl_ID;
	wire extandFlag;
	wire [1:0] PCSrc_ID;
	wire [1:0] Frwd1_ID;
	wire regRead_ID;
	wire [1:0] Frwd2_ID;
	wire Frwrd3_ID;
 	
	wire [31:0] regB_ID;
	wire [31:0] regA_ID;
	wire [31:0] ShamtExt_ID;
	wire [31:0] regA_Frwd;
	wire [31:0] ImmExt_ID;
	wire [31:0] regB_Frwd;
	
	wire reset_EX;
	
	wire regWrite_EX;
	wire memWrite_EX;
	wire memToReg_EX;
	wire enable_MEM_EX;
	wire [3:0] ALUCrl_EX;
	wire [1:0] regDest_EX;
	wire [31:0] regA_EX;
	wire [1:0] ALUSrc1_EX;
	wire [1:0] ALUSrc2_EX;
	wire [31:0] regB_EX;
	wire [4:0] Rt_EX;
	wire [31:0] ShamtExt_EX;
	wire [31:0] Mx1Src_EX;
	wire [4:0] Rd_EX;
	wire [31:0] ImmExt_EX;
	wire Frwrd3_EX;
	wire [31:0] Mx2Src_EX;
	wire [4:0] writeReg_EX;
	wire regRead_EX;
	wire [1:0] Frwd2_EX;
	wire [1:0] Frwd1_EX;
	wire [31:0] pcPlus4_EX;
	wire [31:0] ALUresult_EX;
	
	wire memWrite_MEM;
	wire regWrite_MEM;
	wire memToReg_MEM;
	wire [31:0] ALUresult_MEM;
	wire enable_MEM;
	wire [31:0] editData_MEM;
	wire [4:0] writeReg_MEM;
	wire Frwrd3_MEM;
	wire regRead_MEM;
	wire [31:0] readData_MEM;
	
	wire regWrite_WB;
	wire [31:0] ALUresult_WB;
	wire memToReg_WB;
	wire [31:0] readData_WB;
	wire [4:0] writeReg_WB;
	wire [31:0] write_back;


	
	PCBuffer PC(
		pcRead,
		PC_IF
	);
	PCAdder PCplus4(
		PC_IF,
		pcPlus4_IF
	);
	
	InstructionRAM instruction_RAM(
		.CLOCK(clk),
		.FETCH_ADDRESS(PC_IF >> 2),
		.ENABLE(1'b1),
		.DATA(read_instr)
	);

	PCMux PC_Mux(
		clk,
		reset,
		enable_IF,
		PCSrc_ID,
		pcPlus4_IF,
    	{PC_ID[31:28], instr_ID[25:0], 2'b0},
    	regA_Frwd,
    	pcPlus4_ID + {ImmExt_ID[29:0], 2'b0},
		pcRead
	);	
	
	IF_ID IFIDBuffer(
		clk,
		reset_ID,
		enable_ID,
		read_instr,
		PC_IF,
    	pcPlus4_IF,
    	instr_ID,
    	PC_ID,
		pcPlus4_ID
	);
	
	ControlUnit control_unit(
		instr_ID[31:26],
		instr_ID[25:21],
		instr_ID[20:16],
		instr_ID[5:0],
		regEqual_flag,
		writeReg_EX,
		regWrite_EX,
		regRead_EX,
		writeReg_MEM,
		regWrite_MEM,
		regRead_MEM,
		regWrite_ID,
		memToReg_ID,
		memWrite_ID,
		enable_MEM_ID,
		PCSrc_ID,
		ALUCtrl_ID,
		ALUSrc1_ID,
		ALUSrc2_ID,
		regDest_ID,
		extandFlag,
		regRead_ID,
		Frwd1_ID,
		Frwd2_ID,
		Frwrd3_ID,
		enable_IF,
		enable_ID,
		reset_ID,
		reset_EX
	);
	
	RegisterFile register_file(
		clk,
		instr_ID[25:21],
		instr_ID[20:16],
		writeReg_WB,
		regA_ID,
		regB_ID,
		regWrite_WB,
		write_back
	);
	
	Mux2to1_32 MuxExtend(extandFlag,{16'b0,instr_ID[15:0]},{{16{instr_ID[15]}},instr_ID[15:0]},ImmExt_ID);

	SignExtend ShamtExtend(instr_ID[10:6],ShamtExt_ID);
	ForwardingMux Fwd( 
    Frwd1_ID,
    Frwd2_ID,
	regA_ID,
    regB_ID,
    ALUresult_EX,
    ALUresult_MEM,
    readData_MEM,
	regA_Frwd,
    regB_Frwd
   );
	
	Comparator compRsRt(regA_Frwd ,regB_Frwd ,regEqual_flag);
	
	ID_EX IDEXBuffer( //Huge ... 
    clk,
	reset_EX,
    regWrite_ID,
    regRead_ID,
    memToReg_ID,
    memWrite_ID,
    enable_MEM_ID,
	ALUCtrl_ID,
    ALUSrc1_ID,
    ALUSrc2_ID,
    regDest_ID,
    regA_Frwd,
    regB_Frwd,
    ImmExt_ID,
    ShamtExt_ID,
    instr_ID,
    Frwd1_ID,
    Frwd2_ID,
    Frwrd3_ID,
    pcPlus4_ID,

    regWrite_EX,
    regRead_EX,
    memToReg_EX,
    memWrite_EX,
    enable_MEM_EX,
	ALUCrl_EX,
    ALUSrc1_EX,
    ALUSrc2_EX,
    regDest_EX,
    regA_EX,
    regB_EX,
    ImmExt_EX,
    ShamtExt_EX,
    Rt_EX,
	Rd_EX,
    Frwd1_EX,
    Frwd2_EX,
    Frwrd3_EX,
    pcPlus4_EX
);

	Mux3to1_32 Mx1(ALUSrc1_EX,regA_EX,ShamtExt_EX,pcPlus4_EX,Mx1Src_EX);
	Mux3to1_32 Mx2(ALUSrc2_EX,regB_EX,ImmExt_EX,32'b0,Mx2Src_EX);
	Mux3to1_5 Mx3(regDest_EX,Rd_EX,Rt_EX,5'b11111,writeReg_EX);


	 
	ALU alu(
		Mx1Src_EX,
		Mx2Src_EX,
		ALUCrl_EX,
		ALUresult_EX
	);

	EX_MEM EXMEMBuffer( 
    clk,
    regWrite_EX,
    memToReg_EX,
    memWrite_EX,
    enable_MEM_EX,
    ALUresult_EX,
    writeReg_EX,
    regRead_EX,
    Frwrd3_EX,
    Frwrd3_MEM ? write_back : regB_EX,

    regWrite_MEM,
    memToReg_MEM,
    memWrite_MEM,
    enable_MEM,
    ALUresult_MEM,
    writeReg_MEM,
    regRead_MEM,
    Frwrd3_MEM,
    editData_MEM 
   );

	MainMemory main_memory(
		.CLOCK(clk),
		.ENABLE(enable_MEM),
		.FETCH_ADDRESS(ALUresult_MEM>>2),
		.EDIT_SERIAL({memWrite_MEM,ALUresult_MEM>>2,editData_MEM}),
		.DATA(readData_MEM)
	);
	

	MEM_WB MEMWBBuffer( 
    clk,

    regWrite_MEM,
    memToReg_MEM,
    ALUresult_MEM,
    readData_MEM,
    writeReg_MEM,

    regWrite_WB,
    memToReg_WB,
    ALUresult_WB,
    readData_WB,
    writeReg_WB
   );

	Mux2to1_32 MxWB(memToReg_WB,ALUresult_WB,readData_WB,write_back);

endmodule
