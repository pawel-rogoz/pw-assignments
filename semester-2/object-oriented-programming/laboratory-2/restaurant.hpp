#ifndef RESTAURANT_H
#define RESTAURANT_H

#include <iostream>
#include <vector>
#include <exception>
#include "dish.hpp"

using namespace std;

class Restaurant {
private:
    vector <Dish> dishes;
    string name;
public:
    Restaurant ();
    Restaurant (vector <Dish> dishes, string name);

    void SetName(string name);

    vector <Dish> GetDishes();
    string GetName();

    void AddDish(Dish dish);
    void GetMenu();
};

#endif