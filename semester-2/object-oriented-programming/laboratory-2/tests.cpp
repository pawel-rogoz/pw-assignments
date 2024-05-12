#define CATCH_CONFIG_MAIN
#include "catch.hpp"
#include "restaurant.hpp"
#include "dish.hpp"

TEST_CASE("DishGetNameTest") {
    vector <string> ingredients;
    vector <string> allergens;
    ingredients.push_back("ryz");
    allergens.push_back("orzechy");
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    REQUIRE(dish.GetName() == "Makaron");
}

TEST_CASE("DishGetIngredientsTest") {
    vector <string> ingredients;
    vector <string> allergens;
    ingredients.push_back("ryz");
    allergens.push_back("orzechy");
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    REQUIRE(dish.GetVectorIngredients() == ingredients);
}

TEST_CASE("DishGetAllergensTest") {
    vector <string> ingredients;
    vector <string> allergens;
    ingredients.push_back("ryz");
    allergens.push_back("orzechy");
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    REQUIRE(dish.GetVectorAllergens() == allergens);
}

TEST_CASE("DishGetPriceTest") {
    vector <string> ingredients;
    vector <string> allergens;
    ingredients.push_back("ryz");
    allergens.push_back("orzechy");
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    REQUIRE(dish.GetPrice() == 5.9);
}

TEST_CASE("DishGetIsAvailableTest") {
    vector <string> ingredients;
    vector <string> allergens;
    ingredients.push_back("ryz");
    allergens.push_back("orzechy");
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    REQUIRE(dish.GetIsAvailable() == true);
}

TEST_CASE("DishGetPriceTest") {
    vector <string> ingredients;
    vector <string> allergens;
    ingredients.push_back("ryz");
    allergens.push_back("orzechy");
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    REQUIRE(dish.GetPrice() == 350);
}

TEST_CASE("DishSetPriceTest") {
    vector <string> ingredients;
    vector <string> allergens;
    ingredients.push_back("ryz");
    allergens.push_back("orzechy");
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    dish.SetPrice(6.5);

    REQUIRE(dish.GetPrice() == 6.5);
}

TEST_CASE("DishSetIsAvailableTest") {
    vector <string> ingredients;
    vector <string> allergens;
    ingredients.push_back("ryz");
    allergens.push_back("orzechy");
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    dish.SetIsAvailable(false);

    REQUIRE(dish.GetIsAvailable() == false);
}

TEST_CASE("DishGetKcalTest") {
    vector <string> ingredients;
    vector <string> allergens;
    ingredients.push_back("ryz");
    allergens.push_back("orzechy");
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    dish.SetKcal(400);

    REQUIRE(dish.GetKcal() == 400);
}

TEST_CASE("DishAddIngredientTest") {
    vector <string> ingredients;
    vector <string> allergens;
    vector <string> new_ingredients;
    ingredients.push_back("ryz");
    allergens.push_back("orzechy");
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    new_ingredients = ingredients;
    new_ingredients.push_back("oliwa");

    dish.AddIngredient("oliwa");

    REQUIRE(dish.GetVectorIngredients() == new_ingredients);
}

TEST_CASE("DishAddAllergenTest") {
    vector <string> ingredients;
    vector <string> allergens;
    vector <string> new_allergens;
    ingredients.push_back("ryz");
    allergens.push_back("orzechy");
    Dish dish("Makaron", ingredients, allergens, 5.9, true, 350);

    new_allergens = ingredients;
    new_allergens.push_back("mleko");

    dish.AddAllergen("mleko");

    REQUIRE(dish.GetVectorAllergens() == new_allergens);
}

TEST_CASE("SetPriceBelowZero")
{
    vector <string> ingredients;
    vector <string> allergens;
    Dish dish("Makaron", ingredients, allergens, 7.5, true, 450);

    REQUIRE_THROWS_AS(dish.SetPrice(-1), std::invalid_argument);
}

TEST_CASE("SetKcalBelowZero")
{
    vector <string> ingredients;
    vector <string> allergens;
    Dish dish("Makaron", ingredients, allergens, 7.5, true, 450);

    REQUIRE_THROWS_AS(dish.SetKcal(-5), std::invalid_argument);
}

TEST_CASE("SetNameWithoutLetters")
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

    REQUIRE_THROWS_AS(restaurant.SetName(""), std::invalid_argument);
}