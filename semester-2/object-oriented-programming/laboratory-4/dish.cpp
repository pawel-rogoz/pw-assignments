#include "dish.hpp"
#include <vector>

Dish::Dish(std::vector <Ingredient> ingredients, unsigned int vat, unsigned int margin)
{
    this->ingredients = ingredients;
    this->vat = vat;
    this->margin = margin;
}

void Dish::setVat(unsigned int vat)
{
    this->vat = vat;
}

void Dish::setMargin(unsigned int margin)
{
    this->margin = margin;
}

unsigned int Dish::getVat() const
{
    return this->vat;
}

unsigned int Dish::getMargin() const
{
    return this->margin;
}

float Dish::calcPrice() const
{
    float price = 0;
    for (const& auto element : this->ingredients)
    {
        price += element.getPrice();
    };
    price = price*(1+(this->margin/100));
    price = price*(1+(this->vat/100));
    return price;
}

