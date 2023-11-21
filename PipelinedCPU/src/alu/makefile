test: compile sim

compile:
	iverilog -o alu.out test_alu.v

sim:
	vvp alu.out

clean:
	rm -rf *vcd *.out