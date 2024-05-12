#include <iostream>
#include <vector>
#include "dish.cpp"
#include "restaurant.cpp"
#include <chrono>
#include <fstream>

using namespace std;

int main()
{
    auto start = chrono::high_resolution_clock::now();

    string file = "state.txt";
    ofstream state(file);
    state << "Elements changed:" << endl;

    vector <string> ingredients = {"ryz"};
    vector <string> allergens = {"orzechy"};
    Dish dish = Dish("DANIE", ingredients, allergens, 14.50, true, 485);

    vector <string> ingredients_2 = {"makaron"};
    vector <string> allergens_2 = {"maka"};
    Dish dish_2 = Dish("DANIE2", ingredients_2, allergens_2, 16.40, true, 500);

    dish_2.SetPrice(10.0, file);
    dish_2.AddAllergen("soja", file);
    dish_2.AddIngredient("sos", file);
    dish_2.SetIsAvailable(false, file);
    dish_2.SetKcal(400, file);

    cout << "\nIngredients of: " << dish_2.GetName() << "\n";
    dish_2.GetIngredients();
    cout << "\n" << "Allergens of: " << dish_2.GetName() << "\n";
    dish_2.GetAllergens();
    cout << "\n";
    vector <Dish> dishes = {dish};
    Restaurant restaurant = Restaurant(dishes, "Pod niebem");

    restaurant.AddDish(dish_2, file);
    restaurant.GetMenu();
    cout << "\n";
    restaurant.FindByPrice(16.4);
    restaurant.FindByPrice(19.9);
    restaurant.SetName("AliBaba", file);

    auto end = chrono::high_resolution_clock::now();
    chrono::duration<float> duration = end - start;
    cout << "\nProgram finished in: " << duration.count() << "s" << endl;
}
