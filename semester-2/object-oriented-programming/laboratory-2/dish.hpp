
#ifndef DISH_H
#define DISH_H

#include <iostream>
#include <vector>

using namespace std;

class Dish {
public:
    Dish ();
    Dish (string name, vector <string> ingredients, vector <string> allergens, double price, bool isAvailable, int kcal);

    void SetPrice(double price);
    void SetIsAvailable(bool isAvailable);
    void SetKcal(int kcal);

    vector <string> GetVectorIngredients();
    vector <string> GetVectorAllergens();
    double GetPrice();
    bool GetIsAvailable();
    int GetKcal();
    string GetName();

    void AddIngredient(string ingredient);
    void AddAllergen(string allergen);
    void GetIngredients();
    void GetAllergens();
private:
    vector <string> ingredients;
    vector <string> allergens;
    double price;
    bool isAvailable;
    int kcal;
    string name;
};

#endif