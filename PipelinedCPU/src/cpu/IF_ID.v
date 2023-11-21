module IF_ID( 
    input clk,reset,enable,
	input wire [31:0] instr_in,
    input wire [31:0] pc_in,
    input wire [31:0] pc4_in,
	output reg [31:0] instr_out,
    output reg [31:0] pc_out,
    output reg [31:0] pc4_out
   );

    always @(posedge clk) begin
		if (reset) begin
			instr_out <= 0;
			pc4_out <= 0;
			pc_out <= 0;
		end
		else if (enable) begin
			pc_out <= pc_in;
			pc4_out <= pc4_in;
			instr_out <= instr_in;
		end
    end

endmodule