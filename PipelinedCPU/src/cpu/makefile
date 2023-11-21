test:compile sim
compile:
	iverilog -o run.out test_cpu.v cpu.v
sim:
	vvp -n run.out
clean:
	rm -rf *vcd *.out

