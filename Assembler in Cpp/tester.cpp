/*
 * This is a driver to test pass1 and the Label Table functions.
 *
 * Author: Alyce Brady
 * Date: 2/18/99
 * Modified by: Caitlin Braun and Giancarlo Anemone to test pass2 of the assembler.
 */

#include <stdio.h>
#include <string.h> 
#include "LabelTable.hpp"


using std::cout;
using std::endl;
using std::string;
using std::bitset;
using std::stringstream;
using std::vector;
using std::map;
using std::to_string;
using std::ifstream;
using std::ostream;


int compare_files(FILE* fp1, FILE* fp2)
{
	char char1 = fgetc(fp1);
	char char2 = fgetc(fp2);

	while(char1 != EOF && char2 != EOF){
		if(char1 != char2){
			return -1;
		}
        char1 = fgetc(fp1);
        char2 = fgetc(fp2);
	}
	return 0;
}
int main (int argc, char * argv[])
{   
    if(argc < 4)
    {
        if(argc == 3)
        {
                //If the program is not given an expected output
                //tester still runs and outputs the machine code
                stringstream binary_instructions(phase2Assemble(argv[1]));
                std::ofstream outFile;
                outFile.open(argv[2]);
                outFile << binary_instructions.rdbuf();
                outFile.close();
                return 0;
        }
        printf("Please enter an input file, an output file, and optionally an expected output file \n");
        return 0;
    }

    stringstream binary_instructions(phase2Assemble(argv[1]));
    std::ofstream outFile;
    outFile.open(argv[2]);
    outFile << binary_instructions.rdbuf();
    outFile.close();

    FILE* fp1;
    FILE* fp2;
    fp1 = fopen(argv[3], "r");
    fp2 = fopen(argv[2], "r");

    if(fp1 == NULL || fp2 == NULL){
    	printf("Error: Files are not open correctly \n");
    }

    int res = compare_files(fp1, fp2);

    if(res == 0){
    	printf("ALL PASSED! CONGRATS :) \n");
    }else{
    	printf("YOU DID SOMETHING WRONG :( \n");
    }

    fclose(fp1);
    fclose(fp2);
    
    return 0;
}


