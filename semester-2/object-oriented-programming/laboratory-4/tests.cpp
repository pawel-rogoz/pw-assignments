#define CATCH_CONFIG_MAIN
#include "catch.hpp"
#include "dish.hpp"
#include "ingredient.hpp"

// #include <vector>

TEST_CASE("IngredientSetKcalTest") {
    Ingredient ingredient = Ingredient(6, 0.5);
    ingredient.setKcal(10);
    REQUIRE(ingredient.getKcal() == 10);
}

TEST_CASE("IngredientSetPriceTest") {
    Ingredient ingredient = Ingredient(6, 0.5);
    ingredient.setPrice(4.5);
    REQUIRE(ingredient.getPrice() == 4.5);
}

TEST_CASE("DishSetVatTest") {
    Ingredient ingredient = Ingredient(6, 0.5);
    vector <Ingredient> ingredients = {ingredient};
    Dish dish = Dish(ingredients, 8, 50)
    dish.setVat(10);
    REQUIRE(dish.getVat() == 10);
}

TEST_CASE("DishSetMarginTest") {
    Ingredient ingredient = Ingredient(6, 0.5);
    vector <Ingredient> ingredients = {ingredient};
    Dish dish = Dish(ingredients, 8, 50)
    dish.setMargin(20);
    REQUIRE(dish.getMargin() == 20);
}

TEST_CASE("DishCalcPriceTest") {
    Ingredient ingredient = Ingredient(6, 1.0);
    vector <Ingredient> ingredients = {ingredient};
    Dish dish = Dish(ingredients, 10, 50)
    REQUIRE(dish.calcPrice() == 1.65);
}