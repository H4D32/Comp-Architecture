`include "HazardUnit.v"

module ControlUnit(
	input wire [5:0] opcode,
	input wire [4:0] rs_reg,
	input wire [4:0] rt_reg,
	input wire [5:0] funct,
	input wire regEqual_flag,
	input wire [4:0] writeReg_EX,
	input wire regWrite_EX,
	input wire regRead_EX,
	input wire [4:0] writeReg_MEM,
	input wire regWrite_MEM,
	input wire regRead_MEM,
	output reg reg_write,
	output reg mem_to_reg,
	output reg mem_write,
	output reg mem_used,
	output reg [1:0] pc_src,
	output reg [3:0] ALU_control,
	output reg [1:0] ALU_src_A,
	output reg [1:0] ALU_src_B,
	output reg [1:0] reg_dst,
	output reg ext_sign,
	output reg regRead,
	output wire [1:0] fwd_a,
	output wire [1:0] fwd_b,
	output wire fwd_m,
	output wire enable_IF,
	output wire enable_ID,
	output wire reset_ID,
	output wire reset_EX
   );
	
	reg rs_flag, rt_flag;

localparam
	RegA_RS     = 0,
	RegA_SA     = 1,
	RegA_LNK   = 2,
	RegB_RT     = 0,
	RegB_IMM    = 1,
	RegB_LNK   = 2,
	RegB_BNCH = 3,
	regDest_RD    = 0,
	regDest_RT    = 1,
	regDest_LNK  = 2,
	ADD    = 0,
	ADDU	= 1,
	SUB    = 2,
	SUBU 	= 3,
	AND    = 4,
	NOR		= 5,
	OR		= 6,
	XOR		= 7,
	SLL		= 8,
	SLLV	= 9,
	SRL		= 10,
	SRLV	= 11,
	SRA		= 12,
	SRAV	= 13,
	SLT		= 14;

localparam  
	R_type          = 6'b000000, 
	R_SLL      = 6'b000000,
	R_SRL      = 6'b000010,
	R_SUB      = 6'b100010,
	R_SUBU     = 6'b100011,
	R_AND      = 6'b100100,
	R_SRA      = 6'b000011,
	R_SLLV     = 6'b000100,
	R_SRLV     = 6'b000110, 
	R_SRAV     = 6'b000111,
	R_JR       = 6'b001000,
	R_ADD      = 6'b100000,
	R_ADDU     = 6'b100001,
	R_OR       = 6'b100101,
	R_SLT      = 6'b101010,
	R_SLTU     = 6'b101011,
	J          = 6'b000010,
	JAL        = 6'b000011,
	BEQ        = 6'b000100,
	R_XOR      = 6'b100110,
	R_NOR      = 6'b100111,
	BNE        = 6'b000101,
	ADDI       = 6'b001000,
	ADDIU      = 6'b001001,
	SLTI       = 6'b001010,
	SLTIU      = 6'b001011,
	ANDI       = 6'b001100,
	XORI       = 6'b001110,
	LUI        = 6'b001111,
	ORI        = 6'b001101,
	SW         = 6'b101011,
	LW         = 6'b100011;
	
	reg is_link;
	reg is_store; 
	
	always @(*) begin
		pc_src = 0;
		ext_sign = 0;
		reg_write = 0;
		mem_write = 0;
		mem_to_reg = 0;
		mem_used = 0;
		regRead = 0;
		rs_flag = 0;
		rt_flag = 0;
		is_store = 0;
		is_link = 0;
		ALU_control = ADD;
		ALU_src_A = RegA_RS;
		ALU_src_B = RegB_RT;
		reg_dst = regDest_RD;
		case (opcode)
			R_type: begin
				case (funct)
					R_ADD,R_ADDU: begin
						ALU_control = ADD;
						ALU_src_A = RegA_RS;
						ALU_src_B = RegB_RT;
						mem_to_reg = 0;
						reg_dst = regDest_RD;
						reg_write = 1;
						rs_flag = 1;
						rt_flag = 1;
					end
					R_SUB,R_SUBU: begin
						ALU_control = SUB;
						ALU_src_A = RegA_RS;
						ALU_src_B = RegB_RT;
						mem_to_reg = 0;
						reg_dst = regDest_RD;
						reg_write = 1;
						rs_flag = 1;
						rt_flag = 1;
					end		
					R_AND: begin
						ALU_control = AND;
						ALU_src_A = RegA_RS;
						ALU_src_B = RegB_RT;
						mem_to_reg = 0;
						reg_dst = regDest_RD;
						reg_write = 1;
						rs_flag = 1;
						rt_flag = 1;
					end
					R_NOR: begin
						ALU_control = NOR;
						ALU_src_A = RegA_RS;
						ALU_src_B = RegB_RT;
						mem_to_reg = 0;
						reg_dst = regDest_RD;
						reg_write = 1;
						rs_flag = 1;
						rt_flag = 1;
					end
					R_OR: begin
						ALU_control = OR;
						ALU_src_A = RegA_RS;
						ALU_src_B = RegB_RT;
						mem_to_reg = 0;
						reg_dst = regDest_RD;
						reg_write = 1;
						rs_flag = 1;
						rt_flag = 1;
					end
					R_XOR: begin
						ALU_control = XOR;
						ALU_src_A = RegA_RS;
						ALU_src_B = RegB_RT;
						mem_to_reg = 0;
						reg_dst = regDest_RD;
						reg_write = 1;
						rs_flag = 1;
						rt_flag = 1;
					end
					R_SLL: begin
						ALU_control = SLL;
						ALU_src_A = RegA_SA;
						ALU_src_B = RegB_RT;
						mem_to_reg = 0;
						reg_dst = regDest_RD;
						reg_write = 1;
						rs_flag = 1;
						rt_flag = 1;
					end
					R_SLLV: begin
						ALU_control = SLLV;
						ALU_src_A = RegA_RS;
						ALU_src_B = RegB_RT;
						mem_to_reg = 0;
						reg_dst = regDest_RD;
						reg_write = 1;
						rs_flag = 1;
						rt_flag = 1;
					end
					R_SRL: begin
						ALU_control = SRL;
						ALU_src_A = RegA_SA;
						ALU_src_B = RegB_RT;
						mem_to_reg = 0;
						reg_dst = regDest_RD;
						reg_write = 1;
						rs_flag = 1;
						rt_flag = 1;
					end
					R_SRLV: begin
						ALU_control = SRLV;
						ALU_src_A = RegA_RS;
						ALU_src_B = RegB_RT;
						mem_to_reg = 0;
						reg_dst = regDest_RD;
						reg_write = 1;
						rs_flag = 1;
						rt_flag = 1;
					end
					R_SRA: begin
						ALU_control = SRA;
						ALU_src_A = RegA_SA;
						ALU_src_B = RegB_RT;
						mem_to_reg = 0;
						reg_dst = regDest_RD;
						reg_write = 1;
						rs_flag = 1;
						rt_flag = 1;
					end
					R_SRAV: begin
						ALU_control = SRAV;
						ALU_src_A = RegA_RS;
						ALU_src_B = RegB_RT;
						mem_to_reg = 0;
						reg_dst = regDest_RD;
						reg_write = 1;
						rs_flag = 1;
						rt_flag = 1;
					end	
					R_SLT: begin
						ALU_control = SLT;
						ALU_src_A = RegA_RS;
						ALU_src_B = RegB_RT;
						mem_to_reg = 0;
						reg_dst = regDest_RD;
						reg_write = 1;
						rs_flag = 1;
						rt_flag = 1;
					end
					R_JR: begin
						pc_src = 2;
						rs_flag = 1;
						is_link = 1;
					end
				endcase
			end
			
			ADDI: begin // I Instrs
				ALU_control = ADD;
				ALU_src_A = RegA_RS;
				ALU_src_B = RegB_IMM;
				mem_to_reg = 0;
				reg_dst = regDest_RT;
				reg_write = 1;
				rs_flag = 1;
				ext_sign = 1;
			end
			ADDIU: begin
				ALU_control = ADDU;
				ALU_src_A = RegA_RS;
				ALU_src_B = RegB_IMM;
				mem_to_reg = 0;
				reg_dst = regDest_RT;
				reg_write = 1;
				rs_flag = 1;
				ext_sign = 0;
			end
			ANDI: begin
				ALU_control = AND;
				ALU_src_A = RegA_RS;
				ALU_src_B = RegB_IMM;
				mem_to_reg = 0;
				reg_dst = regDest_RT;
				reg_write = 1;
				rs_flag = 1;
				ext_sign = 0;
			end
			ORI: begin
				ALU_control = OR;
				ALU_src_A = RegA_RS;
				ALU_src_B = RegB_IMM;
				mem_to_reg = 0;
				reg_dst = regDest_RT;
				reg_write = 1;
				rs_flag = 1;
				ext_sign = 0;
			end
			XORI: begin
				ALU_control = XOR;
				ALU_src_A = RegA_RS;
				ALU_src_B = RegB_IMM;
				mem_to_reg = 0;
				reg_dst = regDest_RT;
				reg_write = 1;
				rs_flag = 1;
				ext_sign = 0;
			end
			LW: begin
				ALU_control = ADD;
				ALU_src_B = RegB_IMM;
				mem_to_reg = 1;
				mem_used = 1;
				reg_dst = regDest_RT;
				reg_write = 1;
				ext_sign = 1;
				regRead = 1;
				rs_flag = 1;		
			end
			SW: begin
				ALU_control = ADD;
				ALU_src_B = RegB_IMM;
				mem_write = 1;
				mem_used = 1;
				ext_sign = 1;
				is_store = 1;
				rs_flag = 1;
				rt_flag = 1;
			end
			BEQ: begin
				if (regEqual_flag) begin
					pc_src = 3;
					is_link = 1;
				end
				ext_sign = 1;
				rs_flag = 1;
				rt_flag = 1;
			end
			BNE: begin
				if (~regEqual_flag) begin
					pc_src = 3;
					is_link = 1;
				end
				ext_sign = 1;
				rs_flag = 1;
				rt_flag = 1;
			end
			
			J: begin // J instrs
				pc_src = 1;
				is_link = 1;
			end
			JAL: begin
				pc_src = 1;
				ALU_control = ADD;
				ALU_src_A = RegA_LNK;
				ALU_src_B = RegB_LNK;
				mem_to_reg = 0;
				reg_dst = regDest_LNK;
				reg_write = 1;
				is_link = 1;
			end
		endcase
	end

	HazardUnit HazardCtrl(
	rs_reg,
	rt_reg,
    rs_flag, rt_flag,
    is_link,
	writeReg_EX,
	regWrite_EX,
    regRead_EX,
    writeReg_MEM,
	regWrite_MEM,
    regRead_MEM,
    is_store,
	fwd_a,
	fwd_b,
	fwd_m,
    enable_IF,
	enable_ID,
	reset_ID,
	reset_EX
	);

endmodule
