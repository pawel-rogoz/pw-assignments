#define CATCH_CONFIG_MAIN
#include "catch.hpp"
#include "restaurant.hpp"
#include "dish.hpp"

TEST_CASE("DishGetNameTest") {
    vector <string> ingredients = {"ryz"};
    vector <string> allergens = {"orzechy"};
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    REQUIRE(dish.GetName() == "Makaron");
}

TEST_CASE("DishGetIngredientsTest") {
    vector <string> ingredients = {"ryz"};
    vector <string> allergens = {"orzechy"};
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    REQUIRE(dish.GetVectorIngredients() == ingredients);
}

TEST_CASE("DishGetAllergensTest") {
    vector <string> ingredients = {"ryz"};
    vector <string> allergens = {"orzechy"};
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    REQUIRE(dish.GetVectorAllergens() == allergens);
}

TEST_CASE("DishGetPriceTest") {
    vector <string> ingredients = {"ryz"};
    vector <string> allergens = {"orzechy"};
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    REQUIRE(dish.GetPrice() == 5.9);
}

TEST_CASE("DishGetIsAvailableTest") {
    vector <string> ingredients = {"ryz"};
    vector <string> allergens = {"orzechy"};
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    REQUIRE(dish.GetIsAvailable() == true);
}

TEST_CASE("DishGetKcalTest") {
    vector <string> ingredients = {"ryz"};
    vector <string> allergens = {"orzechy"};
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    REQUIRE(dish.GetKcal() == 350);
}

TEST_CASE("DishSetPriceTest") {
    string file = "tests.txt";
    vector <string> ingredients = {"ryz"};
    vector <string> allergens = {"orzechy"};
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    dish.SetPrice(6.5, file);

    REQUIRE(dish.GetPrice() == 6.5);
}

TEST_CASE("DishSetIsAvailableTest") {
    string file = "tests.txt";
    vector <string> ingredients = {"ryz"};
    vector <string> allergens = {"orzechy"};
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    dish.SetIsAvailable(false, file);

    REQUIRE(dish.GetIsAvailable() == false);
}

TEST_CASE("DishSetKcalTest") {
    string file = "tests.txt";
    vector <string> ingredients = {"ryz"};
    vector <string> allergens = {"orzechy"};
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    dish.SetKcal(400, file);

    REQUIRE(dish.GetKcal() == 400);
}

TEST_CASE("DishAddIngredientTest") {
    string file = "tests.txt";
    vector <string> ingredients = {"ryz"};
    vector <string> allergens = {"orzechy"};
    vector <string> new_ingredients;

    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    new_ingredients = ingredients;
    new_ingredients.push_back("oliwa");

    dish.AddIngredient("oliwa", file);

    REQUIRE(dish.GetVectorIngredients() == new_ingredients);
}

TEST_CASE("DishAddAllergenTest") {
    string file = "tests.txt";
    vector <string> ingredients = {"ryz"};
    vector <string> allergens = {"orzechy"};
    vector <string> new_allergens;

    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    new_allergens = allergens;
    new_allergens.push_back("mleko");

    dish.AddAllergen("mleko", file);

    REQUIRE(dish.GetVectorAllergens() == new_allergens);
}

TEST_CASE("SetPriceBelowZero")
{
    string file = "tests.txt";
    vector <string> ingredients;
    vector <string> allergens;
    Dish dish("Makaron", ingredients, allergens, 7.5, true, 450);

    REQUIRE_THROWS_AS(dish.SetPrice(-1, file), std::invalid_argument);
}

TEST_CASE("SetNameWithoutLetters")
{
    string file = "tests.txt";
    vector <string> ingredients = {"ryz"};
    vector <string> allergens = {"orzechy"};

    Dish dish = Dish("DANIE", ingredients, allergens, 14.50, true, 485);

    vector <string> ingredients_2 = {"makaron"};
    vector <string> allergens_2 = {"maka"};

    Dish dish_2 = Dish("DANIE2", ingredients_2, allergens_2, 19.40, true, 500);

    vector <Dish> dishes = {dish, dish_2};

    Restaurant restaurant = Restaurant(dishes, "Pod niebem");

    REQUIRE_THROWS_AS(restaurant.SetName("", file), std::invalid_argument);
}
