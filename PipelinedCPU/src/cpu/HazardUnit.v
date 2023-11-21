module HazardUnit(
    input wire [4:0] addr_rs,
	input wire [4:0] addr_rt,
    input wire rs_used, rt_used,
    input wire is_link,
	input wire [4:0] writeReg1,
	input wire regWrite1,
    input wire readFlag1,
    input wire [4:0] writeReg2,
	input wire regWrite2,
    input wire readFlag2,
    input wire storeFlag,
	output reg [1:0] fwd_a,
	output reg [1:0] fwd_b,
	output reg fwd_m,
    output wire enable_1,
	output wire enable2,
	output wire reset1,
	output wire reset2
);

	reg stall = 0;
	
	always @(*) begin
		stall = 0;
		fwd_a = 0;
		fwd_b = 0;
		fwd_m = 0;
		if (rs_used && addr_rs != 0) begin
			if (addr_rs == writeReg1 && regWrite1) begin
				if (readFlag1)
					stall = 1;
				else
					fwd_a = 1;
			end 
			else if (addr_rs == writeReg2 && regWrite2) begin
				if (readFlag2)
					fwd_a = 3;
				else
					fwd_a = 2;
			end
		end
		if (rt_used && addr_rt != 0) begin
			if (addr_rt == writeReg1 && regWrite1) begin
				if (readFlag1) begin
					if (storeFlag)
						fwd_m = 1;
					else 
						stall = 1;
				end
				else
					fwd_b = 1;
			end
			else if (addr_rt == writeReg2 && regWrite2) begin
				if (readFlag2)
					fwd_b = 3;
				else
					fwd_b = 2;
			end
		end
	end
	
    Staller StallUnit(is_link,stall,enable_1,enable2,reset1,reset2);


endmodule

module Staller(
    input wire is_link,
    input wire stall,
    output reg enable_1,
	output reg enable2,
	output reg reset1,
	output reg reset2
);

    always @(*) begin
		enable_1 = 1;
		enable2 = 1;
		reset1 = 0;
		reset2 = 0;
		
		if (stall) begin
			enable_1 = 0;
			enable2 = 0;
			reset2 = 1;
		end
		else if (is_link) begin
			reset1 = 1;
		end
	end

endmodule