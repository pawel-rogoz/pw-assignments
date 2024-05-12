#ifndef SHOE_H
#define SHOE_H

#include <string>

using namespace std;

class Shoe {
public:
    Shoe ();
    Shoe (string name, float weight);
    
    string GetName ();
    float GetWeight();

private:
    string name;
    float weight;
};

#endif