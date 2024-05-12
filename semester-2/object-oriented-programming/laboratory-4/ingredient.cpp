#include "ingredient.hpp"

Ingredient::Ingredient(unsigned int kcal, float price)
{
    this->kcal = kcal;
    this->price = price;
}

void Ingredient::setKcal(const unsigned int kcal)
{
    this->kcal = kcal;
}

void Ingredient::setPrice(float price)
{
    this->price = price;
}

unsigned int Ingredient::getKcal() const
{
    return this->kcal;
}

float Ingredient::getPrice() const
{
    return this->price;
}

void Diary::changePriceByPercent(int percent)
{
    this->price = price * (1+(percent/100));
}

void Meat::changePriceByPercent(int percent)
{
    this->price = price * (1+(percent/100));
}

void Vegetable::changePriceByPercent(int percent)
{
    this->price = price * (1+(percent/100));
}

void Pasta::changePriceByPercent(int percent)
{
    this->price = price * (1+(percent/100));
}

Diary::Diary(unsigned int kcal, float price) : Ingredient(kcal, price){}
Meat::Meat(unsigned int kcal, float price) : Ingredient(kcal, price){}
Vegetable::Vegetable(unsigned int kcal, float price) : Ingredient(kcal, price){}
Pasta::Pasta(unsigned int kcal, float price) : Ingredient(kcal, price){}
