#include <iostream>
#include <string>
#include <vector>
#include "dish.hpp"
#include "ingredient.hpp"
using namespace std;

int main()
{
    Diary ingredient = Diary(50, 0.25);
    vector <Ingredient> ingredient = {ingredient};
    Dish dish = Dish(ingredient, 8, 50);
}