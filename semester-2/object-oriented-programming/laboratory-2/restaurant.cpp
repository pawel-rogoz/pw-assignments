#include <iostream>
#include <vector>
#include "dish.hpp"
#include "restaurant.hpp"

using namespace std;

Restaurant::Restaurant() {};

Restaurant::Restaurant(vector <Dish> dishes, string name)
{
    this->dishes = dishes;
    this->name = name;
}

void Restaurant::SetName(string name)
{
    if (name.length() == 0)
        throw std::invalid_argument("Name must have at least one letter");
    this->name=name;
}

vector <Dish> Restaurant::GetDishes()
{
    return this->dishes;
}

string Restaurant::GetName()
{
    return this->name;
}

void Restaurant::AddDish(Dish dish)
{
    this->dishes.push_back(dish);
}

void Restaurant::GetMenu()
{
    int size = this->dishes.size();
    for (int i = 0; i < size; i++)
    {
        Dish dish = this->dishes[i];
        cout << dish.GetName() << ", price: " << dish.GetPrice() << endl;
    }
}