#include <vector>
#include <iostream>
#include <exception>

#include "dish.hpp"

Dish::Dish(){}

Dish::Dish(string name, vector <string> ingredients, vector <string> allergens, double price, bool isAvailable, int kcal)
{
    this->name = name;
    this->ingredients = ingredients;
    this->allergens = allergens;
    this->price = price;
    this->isAvailable = isAvailable;
    this->kcal = kcal;
}

void Dish::SetPrice(double price)
{
    if (price < 0.0)
        throw std::invalid_argument("Price have to be greater than 0");
    this->price = price;
}

void Dish::SetIsAvailable(bool isAvailable)
{
    this->isAvailable = isAvailable;
}

void Dish::SetKcal(int kcal)
{
    if (kcal < 0)
        throw std::invalid_argument("Kcal number have to bre greater or equal 0");
    this->kcal = kcal;
}

vector <string> Dish::GetVectorIngredients()
{
    return this->ingredients;
}

void Dish::GetIngredients()
{
    int size = this->ingredients.size();
    for (int i = 0; i < size; i++)
    {
        cout << this->ingredients[i] << endl;
    }
}

vector <string> Dish::GetVectorAllergens()
{
    return this->allergens;
}

void Dish::GetAllergens()
{
    int size = this->allergens.size();
    for (int i = 0; i < size; i++)
    {
        cout << this->allergens[i];
    }
}

double Dish::GetPrice()
{
    return this->price;
}

bool Dish::GetIsAvailable()
{
    return this->isAvailable;
}

int Dish::GetKcal()
{
    return this->kcal;
}

void Dish::AddIngredient(string ingredient)
{
    this->ingredients.push_back(ingredient);
}

void Dish::AddAllergen(string allergen)
{
    this->allergens.push_back(allergen);
}

string Dish::GetName()
{
    return this->name;
}
