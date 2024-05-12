#include <iostream>
#include <vector>
#include <fstream>
#include "dish.hpp"
#include "restaurant.hpp"

using namespace std;

Restaurant::Restaurant() {};

Restaurant::Restaurant(vector <Dish> dishes, string name)
{
    this->dishes = dishes;
    this->name = name;
}

void Restaurant::SetName(string name, string file)
{
    ofstream state(file, ios::app);
    if (name.length() == 0)
        throw std::invalid_argument("Name must have at least one letter");
    state << "Restaurant: " << this->name << " has now a new name: " << name << endl;
    this->name=name;
}

vector <Dish> Restaurant::GetDishes() const
{
    return this->dishes;
}

string Restaurant::GetName() const
{
    return this->name;
}

void Restaurant::AddDish(Dish dish, string file)
{
    this->dishes.push_back(dish);
    ofstream state(file, ios::app);
    state << "Added new dish: " << dish.GetName() << " to the restaurant: " << this->name << endl;
}

void Restaurant::GetMenu() const
{
    for (const auto& dish : this->dishes)
    {
        cout << dish.GetName() << ", price: " << dish.GetPrice() << endl;
    }
}

void Restaurant::FindByPrice(double price) const
{
    vector <double> prices;
    for (const auto& dish : this->dishes)
    {
        prices.push_back(dish.GetPrice());
    }

    auto result = find(begin(prices), end(prices), price);

    (result != end(prices))
        ? cout << "There is a dish with this price" << endl
        : cout << "There is not a dish with this price" << endl;
}
