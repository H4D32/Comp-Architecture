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

bool operator==(Label label, string string){

    return label.getName() == string;

}

bool operator==(string string, Label label){

    return label.getName() == string;

}


string trim(string line){
    string trim_line;

    if(line.empty()) return "";

    if(line.at(0) == '\t' || line.at(0) == ' '){

        trim_line = line.substr(1);

    } else trim_line = line;

    if(trim_line.back() == '\t' || trim_line.back() == ' '){

        trim_line = trim_line.substr(0, line.size() - 1);

    } 
    return trim_line;
}

stringstream removeComments(ifstream & is) {

    string line; 
    stringstream out; //Stringstream output

    while(getline(is, line)){
        int marker = line.find('#');

        if(marker != -1){
            line.erase(marker);
        }   

        out << line << endl;
    }
    
    return out;
}

void phase1Parse(string iss){
    int inst_counter = 0; 
    
    string line; 
    string trim_line; 
    stringstream is(iss); 

    /* Seeking the .text segment */
    while(getline(is, line)){

        trim_line = trim(line);

        if(trim_line == ".text") break;

    }

    
    /* Parsing*/
    while(getline(is,line)){
        
        trim_line = trim(line);

        if(!trim_line.empty()){

            /* label found */
            if(trim_line.find(':') != string::npos){
                size_t marker = trim_line.find(':');

                Label label(trim_line.substr(0, marker), 0x400000 + (inst_counter * 4));
                labels_vector.push_back(label);
              
            } 

            //increment count if not label
            else inst_counter++;    
        }
    } 
}   