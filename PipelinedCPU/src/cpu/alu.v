
module ALU (
	input wire [31:0] op1, op2,
	input wire [3:0] ALUCtrl,
	output reg [31:0] result
	);



localparam
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

        reg[31:0] Slt_reg;
	always @(*) begin
		result = 0;

		case (ALUCtrl)
			ADD, ADDU: begin
				result = op1 + op2;
			end
			SUB, SUBU: begin
				result = op1 - op2;
			end
			AND: begin
				result = op1 & op2;
			end
			NOR: begin
				result = ~(op1 | op2);
			end
			OR: begin
				result = op1 | op2;
			end
			XOR: begin
				result = op1 ^ op2;
			end
			SLT: begin
				Slt_reg = op1 - op2;
				result = Slt_reg[31];
			end
			SLL: begin
				result = op2 << op1;
			end
			SLLV: begin
				result = op2 << op1[3:0];
			end
			SRL: begin
				result = op2 >> op1;
			end
			SRLV: begin
				result = op2 >> op1[3:0];
			end
			SRA: begin
				result = $signed(op2) >>> op1; 
			end
			SRAV: begin
				result = $signed(op2) >>> op1[3:0];
			end	
		endcase
	end
	
endmodule
