#include <string>

#include "shoe.hpp"

Shoe::Shoe() 
{
    this->name = "";
    this->weight = 0.0;
}

Shoe::Shoe(string name, float weight) 
{
    this->name = name;
    this->weight = weight;
}

float Shoe::GetWeight() 
{
    return this->weight;
}

string Shoe::GetName() 
{
    return this->name;
}