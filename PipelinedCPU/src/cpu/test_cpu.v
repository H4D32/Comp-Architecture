`timescale 1ns/1ps

module test_CPU;
    reg clk, reset;
    integer cnt,i,file;
    CPU uut(
    .clk (clk ),
    .reset(reset)
    );

    //always #50 clk = ~clk;
    initial begin
        $dumpfile("test_cpu.vcd");
        $dumpvars(0, test_CPU);
        clk = 0;
        reset = 0;
        cnt = 0;
        file = $fopen("data.bin","w");

        
        #50 clk = 1;
        reset = 1'b1;
        #50 clk = 0;
        reset = 0;
        

        while (uut.instr_ID!== 32'hffff_ffff) begin
            #50 clk = ~clk;
            
        end
        // Make sure all instructions finish 
        while (cnt != 10) begin
            #50 clk = ~clk;
            
            cnt = cnt + 1;
        end

        for (i=0; i<512; i=i+1) begin
            $fwrite(file, "%b\n", uut.main_memory.DATA_RAM[i]);
            // $display("%b",uut.main_memory.DATA_RAM[i]);
        end
        $fclose(file);
        $display("==============================");
        $display("Test finished.");
        $finish;
    end

endmodule
