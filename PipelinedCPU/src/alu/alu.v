// instruction: 32-bit instruction
// regA/B: 32-bit data in registerA(addr=00000), registerB(addr=00001)
// result: 32-bit result of Alu execution
// flags: 3-bit alu flag
// flags[2] : zero flag
// flags[1] : negative flag
// flags[0] : overflow flag 

module alu(input[31:0] instruction, input[31:0] reg_A, input[31:0] reg_B, output signed [31:0] result, output[2:0] flags);

    
    wire[5:0] opcode;
    reg[5:0] funct;
    logic ovFlow; //Extender

    reg[31:0] ALUout;
    reg[2:0] flagsBuffer;
    reg[31:0] RSBuffer, RTBuffer;

    assign opcode = instruction[31:26];

    parameter
    //r-type all function codes
    add = 6'b100000,
    addu = 6'b100001,
    and_inst = 6'b100100,
    sub = 6'b100010,
    subu = 6'b100011,
    or_inst = 6'b100101,
    xor_inst = 6'b100110,
    nor_inst = 6'b100111,
    slt = 6'b101010,
    sltu = 6'b101011,
    sll = 6'b000000,
    sllv = 6'b000100,
    sra = 6'b000011,
    srav = 6'b000111,
    srl = 6'b000010,
    srlv = 6'b000110,
    //I-type all op codes
    addi = 6'b001000,
    addiu = 6'b001001,
    andi = 6'b001100,
    ori = 6'b001101,
    xori = 6'b001110,
    beq = 6'b000100,
    bne = 6'b000101,
    slti = 6'b001010, 
    sltiu = 6'b001011,
    lw = 6'b100011,
    sw = 6'b101011;

    always @(*) begin

        if(instruction[25:21] == 5'b00000) RSBuffer = reg_A;
        else if (instruction[25:21] == 5'b00001) RSBuffer = reg_B;
        else RSBuffer = 0;

        if(instruction[20:16] == 5'b00000) RTBuffer = reg_A;
        else if (instruction[20:16] == 5'b00001) RTBuffer = reg_B;
        else RTBuffer = 0;

        //Init
        flagsBuffer = 3'b000;

        //Init
        funct = 6'b000000;

        case(opcode)

            6'b000000: begin //R-type

                funct = instruction[5:0];

                case(funct)

                    add: begin

                        {ovFlow, ALUout} = $signed({RSBuffer[31], RSBuffer}) + $signed({RTBuffer[31], RTBuffer});
                        flagsBuffer[2] = (ovFlow != ALUout[31]); //overflowflag
                        if($signed(ALUout) < 0) flagsBuffer[1] = 1'b1; //negflag

                        else if(ALUout == 32'd0) flagsBuffer[0] = 1'b1; //zeroflag
                       
                    end

                    addu: ALUout = RSBuffer + RTBuffer;

                    sub: begin
                        
                        {ovFlow, ALUout} = $signed({RSBuffer[31], RSBuffer}) - $signed({RTBuffer[31], RTBuffer});
                        flagsBuffer[2] = (ovFlow != ALUout[31]);//overflowflag

                        if($signed(ALUout) < 0) flagsBuffer[1] = 1'b1; //negflag

                        else if(ALUout == 32'd0) flagsBuffer[0] = 1'b1; //zeroflag

                    end    

                    subu: ALUout = RSBuffer - RTBuffer;

                    and_inst: ALUout = RSBuffer & RTBuffer;

                    nor_inst: ALUout = ~(RSBuffer | RTBuffer);

                    or_inst: ALUout = RSBuffer | RTBuffer;

                    xor_inst: ALUout = RSBuffer ^ RTBuffer;

                    sll: ALUout = RTBuffer << instruction[10:6];

                    sllv: ALUout = RTBuffer << RSBuffer;

                    srl: ALUout = RTBuffer >> instruction[10:6];

                    srlv: ALUout = RTBuffer >> RSBuffer;

                    sra: ALUout = RTBuffer >>> instruction[10:6];

                    srav: ALUout = RTBuffer >>> RSBuffer;

                    slt: begin
                        
                        ALUout = ($signed(RSBuffer) < $signed(RTBuffer)) ? 1 : 0; 

                        if(ALUout) flagsBuffer[1] = 1'b1; //negFlag

                    end

                    sltu: begin
                        
                        ALUout = (RSBuffer < RTBuffer) ? 1 : 0; 

                        if(ALUout) flagsBuffer[1] = 1'b1; //negFlag

                    end

                endcase
            end

            addi: begin //I-type start here

                {ovFlow, ALUout} = $signed({RSBuffer[31], RSBuffer}) + $signed({{17{instruction[15]}}, instruction[15:0]});
                flagsBuffer[2] = (ovFlow != ALUout[31]);//overflowflag

                if($signed(ALUout) < 0) flagsBuffer[1] = 1'b1; //negflag

                else if(ALUout == 32'd0) flagsBuffer[0] = 1'b1; //zeroflag

            end

            addiu: ALUout = RSBuffer + {{16{instruction[15]}}, instruction[15:0]};

            andi: ALUout = RSBuffer & {{16{1'b0}},instruction[15:0]};

            ori: ALUout = RSBuffer | {{16{1'b0}},instruction[15:0]};

            xori: ALUout = RSBuffer ^ {{16{1'b0}},instruction[15:0]};

            beq: begin
                
                ALUout = ($signed(RSBuffer) == $signed(RTBuffer)) ? instruction[15:0] : 0;
                
                if(ALUout == 0) flagsBuffer[0] = 1'b1; //fail
                
            end

            bne: begin

                ALUout = ($signed(RSBuffer) != $signed(RTBuffer)) ? instruction[15:0] : 0;
                
                if(ALUout == 0) flagsBuffer[0] = 1'b1; //fail

            end

            slti: begin
                
                ALUout = ($signed(RSBuffer) < $signed({{16{instruction[15]}}, instruction[15:0]})) ? 1 : 0; 

                if(ALUout) flagsBuffer[1] = 1'b1; //negflag

            end

            sltiu: begin 
                
                ALUout = RSBuffer < {{16{instruction[15]}}, instruction[15:0]} ? 1 : 0; 

                if(ALUout) flagsBuffer[1] = 1'b1; //negflag

            end

            lw: ALUout = $signed(RTBuffer) + $signed({{16{instruction[15]}}, instruction[15:0]}); 

            sw: ALUout = $signed(RTBuffer) + $signed({{16{instruction[15]}}, instruction[15:0]});

        endcase
    end
                   
    assign result = ALUout;
    assign flags = flagsBuffer;

endmodule            




