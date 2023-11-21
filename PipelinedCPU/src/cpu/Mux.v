module PCMux( 
    input clk,reset,enable,
    input wire [1:0] PCSrc,
	input wire [31:0] pc_plus,
    input wire [31:0] pc_jmp,
    input wire [31:0] pc_jmpr,
    input wire [31:0] pc_brnch,
	output reg [31:0] PC_OUT
   );

    localparam
	PC_PLUS4   = 0,
	PC_JUMP    = 1,
	PC_JR      = 2,
	PC_BRANCH  = 3;

    always @(posedge clk) begin
		if (reset) begin
			PC_OUT <= 32'b0;
		end
		else if (enable) begin
			case (PCSrc)
				PC_PLUS4: PC_OUT <= pc_plus;
				PC_JUMP: PC_OUT <= pc_jmp;
				PC_JR: PC_OUT <= pc_jmpr;
				PC_BRANCH: PC_OUT <= pc_brnch;
			endcase
		end
	end

endmodule

module ForwardingMux( 
    input wire [1:0] Frwd1_ID,
    input wire [1:0] Frwd2_ID,
	input wire [31:0] regA_ID,
    input wire [31:0] regB_ID,
    input wire [31:0] ALUout1,
    input wire [31:0] ALUout2,
    input wire [31:0] read_data,
	output reg [31:0] regA_Frwd,
    output reg [31:0] regB_Frwd
   );

    always @(*) begin
		regA_Frwd = regA_ID;
		regB_Frwd = regB_ID;
		case (Frwd1_ID)
			0: regA_Frwd = regA_ID;
			1: regA_Frwd = ALUout1;
			2: regA_Frwd = ALUout2;
			3: regA_Frwd = read_data;
		endcase
		case (Frwd2_ID)
			0: regB_Frwd = regB_ID;
			1: regB_Frwd = ALUout1;
			2: regB_Frwd = ALUout2;
			3: regB_Frwd = read_data;
		endcase
	end

endmodule


module Mux3to1_32( 
    input wire [1:0] select,
	input wire [31:0] in1,
    input wire [31:0] in2,
    input wire [31:0] in3,
	output reg [31:0] out
   );

	always @ (*) begin
	case (select)
			0: out = in1;
			1: out = in2;
			2: out = in3;
	endcase
	end

endmodule

module Mux3to1_5( 
    input wire [1:0] select,
	input wire [4:0] in1,
    input wire [4:0] in2,
    input wire [4:0] in3,
	output reg [4:0] out
   );

	always @ (*) begin
	case (select)
			0: out = in1;
			1: out = in2;
			2: out = in3;
	endcase
	end

endmodule

module Mux2to1_32( 
    input wire select,
	input wire [31:0] in1,
    input wire [31:0] in2,
	output reg [31:0] out
   );

	always @ (*) begin
	case (select)
			0: out = in1;
			1: out = in2;
	endcase
	end

endmodule

module Mux2to1_reg( 
    input wire [4:0] select,
	input wire [31:0] in1,
    input wire [31:0] in2,
	output reg [31:0] out
   );

	always @ (*) begin
	case (select)
			0: out = in1;
			default: out = in2;
	endcase
	end

endmodule

