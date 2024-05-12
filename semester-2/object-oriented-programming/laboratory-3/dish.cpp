#include <vector>
#include <iostream>
#include <exception>
#include <fstream>

#include "dish.hpp"

Dish::Dish(){}

Dish::Dish(string name, vector <string> ingredients, vector <string> allergens, double price, bool isAvailable, unsigned int kcal)
{
    this->name = name;
    this->ingredients = ingredients;
    this->allergens = allergens;
    this->price = price;
    this->isAvailable = isAvailable;
    this->kcal = kcal;
}

void Dish::SetPrice(double price, string file)
{
    if (price < 0.0)
        throw std::invalid_argument("Price have to be greater than 0");
    ofstream state(file, ios::app);
    state << "Price of: " << this->name << " is now set as: " << price << endl;
    this->price = price;
}

void Dish::SetIsAvailable(bool isAvailable, string file)
{
    this->isAvailable = isAvailable;
    ofstream state(file, ios::app);
    if (isAvailable)
    {
        state << this->name << " is now available" << endl;
    }
    else
    {
        state << this->name << " is now not available" << endl;
    }
}

void Dish::SetKcal(int kcal, string file)
{
    if (kcal < 0)
        throw std::invalid_argument("Kcal number have to bre greater or equal 0");
    ofstream state(file, ios::app);
    state << "Kcal of: " << this->name << " is now set as: " << kcal << endl;
    this->kcal = kcal;
}

vector <string> Dish::GetVectorIngredients() const
{
    return this->ingredients;
}

void Dish::GetIngredients() const
{
    for (const auto& element : this->ingredients)
    {
        cout << element << endl;
    }
}

vector <string> Dish::GetVectorAllergens() const
{
    return this->allergens;
}

void Dish::GetAllergens() const
{
    for (const auto& element : this->allergens)
    {
        cout << element << endl;
    }
}

double Dish::GetPrice() const
{
    return this->price;
}

bool Dish::GetIsAvailable() const
{
    return this->isAvailable;
}

int Dish::GetKcal() const
{
    return this->kcal;
}

void Dish::AddIngredient(string ingredient, string file)
{
    ofstream state(file, ios::app);
    state << this->name << " now has a new ingredient: " << ingredient << endl;
    this->ingredients.push_back(ingredient);
}

void Dish::AddAllergen(string allergen, string file)
{
    ofstream state(file, ios::app);
    state << this->name << " now has a new allergen: " << allergen << endl;
    this->allergens.push_back(allergen);
}

string Dish::GetName() const
{
    return this->name;
}
