#ifndef DISH_H
#define DISH_H

#include <vector>
#include "ingredient.hpp"

class Dish
{
private:
    std::vector <Ingredient> ingredients;
    unsigned int vat;
    unsigned int margin;
public:
    Dish(std::vector <Ingredient> ingredients, unsigned int vat, unsigned int margin);
    void setVat(unsigned int vat);
    void setMargin(unsigned int margin);
    unsigned int getVat() const;
    unsigned int getMargin() const;
    float calcPrice() const;
};

#endif