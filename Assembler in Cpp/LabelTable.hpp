#ifndef _LabelTable_h
#define _LabelTable_h

#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <map>
#include <fstream>
#include <bitset>
#include <algorithm>

/* 
 * New class to Define a proper data structure for labels with their addresses
 */
class Label{

    public:

        Label(std::string name, int32_t address){
        this->name = name;
        this->address = address;
        }

        int32_t getAddress(){
            return address;
        }

        std::string getName(){
            return name;
        }

    private:

        std::string name;
        int32_t address;

        friend bool operator==(Label label, std::string string);
        friend bool operator==(std::string string, Label label);
};

/* Overloading*/
bool operator==(Label label, std::string string);
bool operator==(std::string string, Label label);

/* Storage for labels*/
inline std::vector<Label> labels_vector;

/* registers name -> number */
inline std::map<std::string, int> reg_map = {

    {"$zero", 0}, {"$at", 1}, {"$v0", 2}, {"$v1", 3}, {"$a0", 4}, {"$a1", 5}, {"$a2", 6}, {"$a3", 7},
    {"$t0", 8}, {"$t1", 9}, {"$t2", 10}, {"$t3", 11}, {"$t4", 12}, {"$t5", 13}, {"$t6", 14}, {"$t7", 15},
    {"$s0", 16}, {"$s1", 17}, {"$s2", 18}, {"$s3", 19}, {"$s4", 20}, {"$s5", 21}, {"$s6", 22}, {"$s7", 23},
    {"$t8", 24}, {"$t9", 25}, {"$k0", 26}, {"$k1", 27}, {"$gp", 28}, {"$sp", 29}, {"$fp", 30}, {"$ra", 31}

};

/* R instruction -> funct */
inline std::map<std::string, std::string> R_Map {

    {"add", "100000"}, {"addu", "100001"}, {"and", "100100"}, {"div", "011010"}, {"divu", "011011"},
    {"jalr", "001001"}, {"jr", "001000"}, {"mfhi", "010000"}, {"mflo", "010010"}, {"mthi", "010001"},
    {"mtlo", "010011"}, {"mult", "011000"}, {"multu", "011001"}, {"nor", "100111"}, {"or", "100101"},
    {"sll", "000000"}, {"sllv", "000100"}, {"slt", "101010"}, {"sltu", "101011"}, {"sra", "000011"},
    {"srav", "000111"}, {"srl", "000010"}, {"srlv", "000110"}, {"sub", "100010"}, {"subu", "100011"},
    {"syscall", "001100"}, {"xor", "100110"}

};

/* I instruction -> op-code */
inline std::map<std::string, std::string> I_Map {

    {"addi", "001000"}, {"addiu", "001001"}, {"andi", "001100"}, {"beq", "000100"}, {"bgez", "000001"},
    {"bgtz", "000111"}, {"blez", "000110"}, {"bltz", "000001"}, {"bne", "000101"}, {"lb", "100000"}, 
    {"lbu", "100100"}, {"lh", "100001"}, {"lhu", "100101"}, {"lui", "001111"}, {"lw", "100011"}, 
    {"ori", "001101"}, {"sb", "101000"}, {"slti", "001010"},{"sltiu", "001011"}, {"sh", "101001"}, 
    {"sw", "101011"}, {"xori", "001110"}, {"swr", "101110"}, {"swl", "101010"}, {"lwr", "100110"},  
    {"lwl", "100010"}

};

/* J instruction -> op_code */
inline std::map<std::string, std::string> J_Map {
    
    {"j", "000010"}, {"jal", "000011"}
    
};

/* parsing to store the labels */
void phase1Parse(std::string iss);

/* parsing again to translate instructions */
std::stringstream phase2Parse(std::stringstream & is);

/* Simple whitespace Trim */
std::string trim(std::string line);

std::stringstream removeComments(std::ifstream & is);

/* get address from label list*/
int labelNameToAddr(std::string label);

/* register -> 5-bit addr */
std::string regToAddr(std::string reg);

/* make machine code for R-types */
std::string assemble_R(std::string instruction, std::string rd, std::string rs, std::string rt, std::string shamt, std::string funct);

/* make machine code for I-types */
std::string assemble_I(std::string instruction, std::string op, std::string rs, std::string rt, std::string immediate);

/* make machine code for J-types */
std::string assemble_J(std::string op, std::string address);

std::stringstream phase2Assemble(std::string filename);

#endif