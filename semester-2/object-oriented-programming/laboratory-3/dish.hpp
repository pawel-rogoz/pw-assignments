
#ifndef DISH_H
#define DISH_H

#include <iostream>
#include <vector>
#include <fstream>

using namespace std;

class Dish {
public:
    Dish ();
    Dish (string name, vector <string> ingredients, vector <string> allergens, double price, bool isAvailable, unsigned int kcal);

    void SetPrice(double price, string file);
    void SetIsAvailable(bool isAvailable, string file);
    void SetKcal(int kcal, string file);

    vector <string> GetVectorIngredients() const;
    vector <string> GetVectorAllergens() const;
    double GetPrice() const;
    bool GetIsAvailable() const;
    int GetKcal() const;
    string GetName() const;

    void AddIngredient(string ingredient, string file);
    void AddAllergen(string allergen, string file);
    void GetIngredients() const;
    void GetAllergens() const;
private:
    vector <string> ingredients;
    vector <string> allergens;
    double price;
    bool isAvailable;
    int kcal;
    string name;
};

#endif
