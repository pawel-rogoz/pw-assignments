#ifndef RESTAURANT_H
#define RESTAURANT_H

#include <iostream>
#include <vector>
#include <fstream>
#include <chrono>
#include "dish.hpp"

using namespace std;

class Restaurant {
private:
    vector <Dish> dishes;
    string name;
public:
    Restaurant ();
    Restaurant (vector <Dish> dishes, string name);

    void SetName(string name, string file);

    vector <Dish> GetDishes() const;
    string GetName() const;

    void AddDish(Dish dish, string file);
    void GetMenu() const;
    void FindByPrice(double price) const;
};

#endif
