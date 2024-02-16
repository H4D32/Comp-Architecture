# Computer Architecture

2 main projects done while learning Computer architecture at the Chinese University of Hong Kong, Shenzhen

## 2-phase MIPS assembler coded in C++

![image](https://github.com/H4D32/Comp-Architecture/assets/49611754/f94f8d07-6a01-4dfc-99f0-bf8638f4bfd1)

We design our C++ code to take inputs such as: 
```
# MIPS code:
 .text
R: add $s0, $s1, $s2 #r instructions 
addu $s0, $s1, $s2 
sub $s0, $s1, $s2 
subu $s0, $s1, $s2
```
And transform to machine code output:
```
00000010001100101000000000100000 
00000010001100101000000000100001 
00000010001100101000000000100010 
00000010001100101000000000100011
```

## 5-stage pipelined CPU simulation in verilog with Hazard detection
* Standalone ALU design: 
The design is relatively simple. Just check for all different cases first for R-type opcode and funct and then implement the I-type instructions and Jump output.
But I must say that the alu.v used in the pipelined cpu (second part) is different since it takes in a 3 bit ALU control signal rather than the whole instruction so it is simpler and the decoding is done elsewhere
![image](https://github.com/H4D32/Comp-Architecture/assets/49611754/e245e9bf-60e9-4e90-b31e-5b4424889261)

* 5-stage pipeline for the CPU:

A 5-stage pipelined CPU is a processor architecture that breaks down the execution of instructions into five stages: instruction fetch, instruction decode, execute, memory access, and write back. Each stage in the pipeline operates on a different instruction simultaneously, increasing the processor's throughput and reducing the overall execution time. However, the pipelined CPU is also prone to hazards that can lead to incorrect program execution. To prevent these hazards, we implement hazard detection logic that stalls the pipeline when necessary.
Even if the project is heavy on workload and hard to implement. The actual design of the cpu is clear and can be confined to dataflow charts such as the one below:
![image](https://github.com/H4D32/Comp-Architecture/assets/49611754/ccfaff1f-59af-49c7-8364-582c0c3f0d47)

Please refer to PipelinedCPU/report.pdf for more details on the implementation or check the source code in verilog



