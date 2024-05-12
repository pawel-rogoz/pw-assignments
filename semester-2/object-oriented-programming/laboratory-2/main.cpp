#include <iostream>
#include <vector>
#include "dish.cpp"
#include "restaurant.cpp"

using namespace std;

int main()
{
    vector <string> ingredients;
    ingredients.push_back("ryz");
    vector <string> allergens;
    ingredients.push_back("orzechy");
    Dish dish = Dish("DANIE", ingredients, allergens, 14.50, true, 485);
    vector <string> ingredients_2;
    ingredients.push_back("makaron");
    vector <string> allergens_2;
    ingredients.push_back("mąka");
    Dish dish_2 = Dish("DANIE2", ingredients_2, allergens_2, 19.40, true, 500);
    vector <Dish> dishes;
    dishes.push_back(dish);
    dishes.push_back(dish_2);
    Restaurant restaurant = Restaurant(dishes, "Pod niebem");
    restaurant.GetMenu();
}