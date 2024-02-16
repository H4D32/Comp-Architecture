# Computer Architecture

2 main projects done while learning Computer architecture at the Chinese University of Hong Kong, Shenzhen

* 2-phase MIPS assembler coded in C++

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

* 5-stage pipelined CPU simulation in verilog with Hazard detection
