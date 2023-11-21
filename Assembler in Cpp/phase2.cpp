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


string regToAddr(string reg){

    string result;

    for(char const & ch: reg){

        if(isdigit(ch) != 0) {

            return reg;

        } else break;
    }

    auto iter = reg_map.find(reg);

    if(iter != reg_map.end()){
        // 5-bit addr
        result = bitset<5>(iter->second).to_string();
    
        return result;

    } else return "";
}

int labelNameToAddr(string label){
    
    for(auto & elem: labels_vector){

        if(label == elem){

            return elem.getAddress();

        }
    
    }

    return -1;
}

string assemble_R(string instruction, string rd, string rs, string rt, string shamt, string funct){

    string op = "000000";
    string destination = regToAddr(rd);
    string first_reg = regToAddr(rs);
    string second_reg = regToAddr(rt);

    int temp = stoi(shamt);
    string shift_amnt = bitset<5>(temp).to_string();

    if(first_reg.empty()) first_reg = "00000";
    if(second_reg.empty()) second_reg = "00000";
    if(destination.empty()) destination = "00000";

    return op + first_reg + second_reg + destination + shift_amnt + funct;

}

string assemble_I(string instruction, string op, string rs, string rt, string immediate){

    string first_reg = regToAddr(rs);
    string destination = regToAddr(rt);
    int temp = stoi(immediate);
    string im_bit = bitset<16>(temp).to_string();

    if(first_reg.empty()) first_reg = "00000";

    if(destination.empty()) destination = "00000";
    
    return op + first_reg + destination + im_bit;

}

string assemble_J(string op, string address){
    
    int temp = stoi(address);
    string address_bit = bitset<26>(temp).to_string();

    return op + address_bit;
}

stringstream phase2Parse(stringstream & is){
    int phase2Counter = 0;
    string line;
    string trim_line;
    stringstream result;

    /* Seeking .text segment */
    while(getline(is, line)){

        trim_line = trim(line);

        if(trim_line == ".text") break;

    }

    /* .text found, we loop */
    while(getline(is, line)){
        //result << to_string(phase2Counter) << endl;
        trim_line = trim(line);

        if(!trim_line.empty()){

            /* dont increment counter for Label */
            if(trim_line.find(':') != string::npos) continue;

            vector<string> tokens; 
            stringstream ss(trim_line); 
            string temp_string; 

            /* push to tokens */
            while(getline(ss, temp_string, ' ')){
                
                if(!temp_string.empty()){
                    if(temp_string.back() == ',') {
                        
                        tokens.push_back(temp_string.substr(0, temp_string.size() - 1));

                    } else tokens.push_back(temp_string);
                }    
            }

            map<string, string>::iterator iter;
            // In Alphabetical Order : 
                // R-Type
            if(tokens[0] == "add"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], tokens[2], tokens[3], "0", iter->second) << endl;

            } else if(tokens[0] == "addu"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], tokens[2], tokens[3], "0", iter->second) << endl;

            } else if(tokens[0] == "and"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], tokens[2], tokens[3], "0", iter->second) << endl;

            } else if(tokens[0] == "div"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], "", tokens[1], tokens[2], "0", iter->second) << endl;

            } else if(tokens[0] == "divu"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], "", tokens[1], tokens[2], "0", iter->second) << endl;

            } else if(tokens[0] == "jalr"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], tokens[2],"", "0", iter->second) << endl;

            } else if(tokens[0] == "jr"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], "", tokens[1],"", "0", iter->second) << endl;

            } else if(tokens[0] == "mfhi"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], "", "", "0", iter->second) << endl;

            } else if(tokens[0] == "mflo"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], "", "", "0", iter->second) << endl;

            } else if(tokens[0] == "mthi"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], "", tokens[1], "", "0", iter->second) << endl;

            } else if(tokens[0] == "mtlo"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], "", tokens[1], "", "0", iter->second) << endl;

            } else if(tokens[0] == "mult"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], "", tokens[1], tokens[2], "0", iter->second) << endl;

            } else if(tokens[0] == "multu"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], "", tokens[1], tokens[2], "0", iter->second) << endl;

            } else if(tokens[0] == "nor"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], tokens[2], tokens[3], "0", iter->second) << endl;

            } else if(tokens[0] == "or"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], tokens[2], tokens[3], "0", iter->second) << endl;

            } else if(tokens[0] == "sll"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], "", tokens[2], tokens[3], iter->second) << endl;

            } else if(tokens[0] == "sllv"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], tokens[3], tokens[2], "0", iter->second) << endl;

            } else if(tokens[0] == "slt"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], tokens[2], tokens[3], "0", iter->second) << endl;

            } else if(tokens[0] == "sltu"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], tokens[2], tokens[3], "0", iter->second) << endl;

            } else if(tokens[0] == "sra"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], "", tokens[2], tokens[3], iter->second) << endl;

            } else if(tokens[0] == "srav"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], tokens[3], tokens[2], "0", iter->second) << endl;

            } else if(tokens[0] == "srl"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], "", tokens[2], tokens[3], iter->second) << endl;

            } else if(tokens[0] == "srlv"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], tokens[3], tokens[2], "0", iter->second) << endl;

            } else if(tokens[0] == "sub"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], tokens[2], tokens[3], "0", iter->second) << endl;
                
            } else if(tokens[0] == "subu"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], tokens[2], tokens[3], "0", iter->second) << endl;
                
            } else if(tokens[0] == "syscall"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], "", "", "", "0", iter->second) << endl;

            } else if(tokens[0] == "xor"){

                iter = R_Map.find(tokens[0]);
                result << assemble_R(tokens[0], tokens[1], tokens[2], tokens[3], "0", iter->second) << endl;
                // I-Type
            } else if(tokens[0] == "addi"){

                iter = I_Map.find(tokens[0]);
                result << assemble_I(tokens[0], iter->second, tokens[2], tokens[1], tokens[3]) << endl;

            } else if(tokens[0] == "addiu"){

                iter = I_Map.find(tokens[0]);
                result << assemble_I(tokens[0], iter->second, tokens[2], tokens[1], tokens[3]) << endl;

            } else if(tokens[0] == "andi"){

                iter = I_Map.find(tokens[0]);
                result << assemble_I(tokens[0], iter->second, tokens[2], tokens[1], tokens[3]) << endl;

            } else if(tokens[0] == "beq"){

                iter = I_Map.find(tokens[0]);
                int temp = labelNameToAddr(tokens[3]);

                if(temp == -1){

                    result << assemble_I(tokens[0], iter->second, tokens[1], tokens[2], tokens[3]) << endl;

                } else {

                    int relative_addr = temp - (0x400000 + ((phase2Counter *4) + 4));
                    result << assemble_I(tokens[0], iter->second, tokens[1], tokens[2], to_string(relative_addr/4)) << endl;

                }

            } else if(tokens[0] == "bgez"){

                iter = I_Map.find(tokens[0]);
                int temp = labelNameToAddr(tokens[2]);

                if(temp == -1){    
                    
                    result << assemble_I(tokens[0], iter->second, tokens[1], "00001", tokens[2]) << endl;

                } else {

                    int relative_addr = temp - (0x400000 + ((phase2Counter *4) + 4));
                    result << assemble_I(tokens[0], iter->second, tokens[1], "00001", to_string(relative_addr/4)) << endl;

                }

            } else if(tokens[0] == "bgtz"){

                iter = I_Map.find(tokens[0]);
                int temp = labelNameToAddr(tokens[2]);

                if(temp == -1){    
                    
                    result << assemble_I(tokens[0], iter->second, tokens[1], "00000", tokens[2]) << endl;

                } else {

                    int relative_addr = temp - (0x400000 + ((phase2Counter *4) + 4));
                    result << assemble_I(tokens[0], iter->second, tokens[1], "00000", to_string(relative_addr/4)) << endl;

                }

            } else if(tokens[0] == "blez"){

                iter = I_Map.find(tokens[0]);
                int temp = labelNameToAddr(tokens[2]);

                if(temp == -1){    
                    
                    result << assemble_I(tokens[0], iter->second, tokens[1], "00000", tokens[2]) << endl;

                } else {

                    int relative_addr = temp - (0x400000 + ((phase2Counter *4) + 4));
                    result << assemble_I(tokens[0], iter->second, tokens[1], "00000", to_string(relative_addr/4)) << endl;

                }

            } else if(tokens[0] == "bltz"){

                iter = I_Map.find(tokens[0]);
                int temp = labelNameToAddr(tokens[2]);

                if(temp == -1){    
                    
                    result << assemble_I(tokens[0], iter->second, tokens[1], "00000", tokens[2]) << endl;

                } else {

                    int relative_addr = temp - (0x400000 + ((phase2Counter *4) + 4));
                    result << assemble_I(tokens[0], iter->second, tokens[1], "00000", to_string(relative_addr/4)) << endl;

                }

            } else if(tokens[0] == "bne"){

                iter = I_Map.find(tokens[0]);
                int temp = labelNameToAddr(tokens[3]);

                if(temp == -1){

                    result << assemble_I(tokens[0], iter->second, tokens[1], tokens[2], tokens[3]) << endl;

                } else {
                    int relative_addr = temp - (0x400000 + ((phase2Counter *4) + 4));
                    result << assemble_I(tokens[0], iter->second, tokens[1], tokens[2], to_string(relative_addr/4)) << endl;

                }

            } else if(tokens[0] == "lb"){

                iter = I_Map.find(tokens[0]);
                size_t open_bracket = tokens[2].find('(');
                size_t close_bracket = tokens[2].find(')');
                string rs = tokens[2].substr(open_bracket + 1, close_bracket - (open_bracket + 1));

                result << assemble_I(tokens[0], iter->second, rs, tokens[1], tokens[2]) << endl;

            } else if(tokens[0] == "lbu"){

                iter = I_Map.find(tokens[0]);
                size_t open_bracket = tokens[2].find('(');
                size_t close_bracket = tokens[2].find(')');
                string rs = tokens[2].substr(open_bracket + 1, close_bracket - (open_bracket + 1));

                result << assemble_I(tokens[0], iter->second, rs, tokens[1], tokens[2]) << endl;

            } else if(tokens[0] == "lh"){

                iter = I_Map.find(tokens[0]);
                size_t open_bracket = tokens[2].find('(');
                size_t close_bracket = tokens[2].find(')');
                string rs = tokens[2].substr(open_bracket + 1, close_bracket - (open_bracket + 1));

                result << assemble_I(tokens[0], iter->second, rs, tokens[1], tokens[2]) << endl;

            } else if(tokens[0] == "lhu"){

                iter = I_Map.find(tokens[0]);
                size_t open_bracket = tokens[2].find('(');
                size_t close_bracket = tokens[2].find(')');
                string rs = tokens[2].substr(open_bracket + 1, close_bracket - (open_bracket + 1));

                result << assemble_I(tokens[0], iter->second, rs, tokens[1], tokens[2]) << endl;

            } else if(tokens[0] == "lui"){

                iter = I_Map.find(tokens[0]);
                result << assemble_I(tokens[0], iter->second, "00000", tokens[1], tokens[2]) << endl;

            } else if(tokens[0] == "lw"){

                iter = I_Map.find(tokens[0]);
                size_t open_bracket = tokens[2].find('(');
                size_t close_bracket = tokens[2].find(')');
                string rs = tokens[2].substr(open_bracket + 1, close_bracket - (open_bracket + 1));

                result << assemble_I(tokens[0], iter->second, rs, tokens[1], tokens[2]) << endl;

            } else if(tokens[0] == "lwl"){

                iter = I_Map.find(tokens[0]);
                size_t open_bracket = tokens[2].find('(');
                size_t close_bracket = tokens[2].find(')');
                string rs = tokens[2].substr(open_bracket + 1, close_bracket - (open_bracket + 1));

                result << assemble_I(tokens[0], iter->second, rs, tokens[1], tokens[2]) << endl;

            } else if(tokens[0] == "lwr"){

                iter = I_Map.find(tokens[0]);
                size_t open_bracket = tokens[2].find('(');
                size_t close_bracket = tokens[2].find(')');
                string rs = tokens[2].substr(open_bracket + 1, close_bracket - (open_bracket + 1));

                result << assemble_I(tokens[0], iter->second, rs, tokens[1], tokens[2]) << endl;

            } else if(tokens[0] == "ori"){

                iter = I_Map.find(tokens[0]);
                result << assemble_I(tokens[0], iter->second, tokens[2], tokens[1], tokens[3]) << endl;

            } else if(tokens[0] == "sb"){

                iter = I_Map.find(tokens[0]);
                size_t open_bracket = tokens[2].find('(');
                size_t close_bracket = tokens[2].find(')');
                string rs = tokens[2].substr(open_bracket + 1, close_bracket - (open_bracket + 1));

                result << assemble_I(tokens[0], iter->second, rs, tokens[1], tokens[2]) << endl;

            } else if(tokens[0] == "sh"){

                iter = I_Map.find(tokens[0]);
                size_t open_bracket = tokens[2].find('(');
                size_t close_bracket = tokens[2].find(')');
                string rs = tokens[2].substr(open_bracket + 1, close_bracket - (open_bracket + 1));

                result << assemble_I(tokens[0], iter->second, rs, tokens[1], tokens[2]) << endl;

            } else if(tokens[0] == "slti"){

                iter = I_Map.find(tokens[0]);
                result << assemble_I(tokens[0], iter->second, tokens[2], tokens[1], tokens[3]) << endl;

            } else if(tokens[0] == "sltiu"){

                iter = I_Map.find(tokens[0]);
                result << assemble_I(tokens[0], iter->second, tokens[2], tokens[1], tokens[3]) << endl;

            } else if(tokens[0] == "sw"){

                iter = I_Map.find(tokens[0]);
                size_t open_bracket = tokens[2].find('(');
                size_t close_bracket = tokens[2].find(')');
                string rs = tokens[2].substr(open_bracket + 1, close_bracket - (open_bracket + 1));

                result << assemble_I(tokens[0], iter->second, rs, tokens[1], tokens[2]) << endl;

            } else if(tokens[0] == "swl"){

                iter = I_Map.find(tokens[0]);
                size_t open_bracket = tokens[2].find('(');
                size_t close_bracket = tokens[2].find(')');
                string rs = tokens[2].substr(open_bracket + 1, close_bracket - (open_bracket + 1));

                result << assemble_I(tokens[0], iter->second, rs, tokens[1], tokens[2]) << endl;

            } else if(tokens[0] == "swr"){

                iter = I_Map.find(tokens[0]);
                size_t open_bracket = tokens[2].find('(');
                size_t close_bracket = tokens[2].find(')');
                string rs = tokens[2].substr(open_bracket + 1, close_bracket - (open_bracket + 1));

                result << assemble_I(tokens[0], iter->second, rs, tokens[1], tokens[2]) << endl;

            } else if(tokens[0] == "xori"){

                iter = I_Map.find(tokens[0]);
                result << assemble_I(tokens[0], iter->second, tokens[2], tokens[1], tokens[3]) << endl;
                // J-type
            } else if(tokens[0] == "j"){

                iter = J_Map.find(tokens[0]);
                int temp = labelNameToAddr(tokens[1]);

                if(temp == -1){
                    
                    result << assemble_J(iter->second, tokens[1]) << endl;

                } else {

                    result <<assemble_J(iter->second, to_string(temp/4)) << endl;

                }
        
            } else if(tokens[0] == "jal"){

                iter = J_Map.find(tokens[0]);
                int temp = labelNameToAddr(tokens[1]);

                if(temp == -1){

                    result << assemble_J(iter->second, tokens[1]) << endl;

                } else {

                    result <<assemble_J(iter->second, to_string(temp>>2)) << endl;

                }

            }
            phase2Counter++;
            tokens.clear();         
        }   
    }

    return result;
}

stringstream phase2Assemble(string filename) {

    ifstream inputfile;
    stringstream result;
    inputfile.open(filename);
    if(inputfile.is_open()){
        stringstream formatted_file = removeComments(inputfile);
        string formatted_string = formatted_file.str();
        phase1Parse(formatted_string);
        result = phase2Parse(formatted_file);
    }
    inputfile.close();
    return result;
}