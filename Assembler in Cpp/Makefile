
testx: tester.o phase1.o phase2.o
	g++ tester.o phase1.o phase2.o -o testx -w

tester.o: tester.cpp
	g++ -c tester.cpp -w

phase1.o: phase1.cpp
	g++ -c phase1.cpp -w

phase2.o: phase2.cpp
	g++ -c phase2.cpp -w

expect: 
	./testx testfile.asm output.txt expectedoutput.txt
	rm output.txt

clean:
	rm *.o testx
