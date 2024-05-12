#include "creator.h"

std::unique_ptr<Ingredient> Creator::create(const Type &type, unsigned int kcal, float price)
{
    switch (type)
    {
    case Types::DAIRY:
        return std::make_unique<Diary>(kcal, price);
    case Types::MEAT:
        return std::make_unique<Meat>(kcal, price);
    case Types::VEGETABLE:
        return std::make_unique<Vegetable>(kcal, price);
    case Types::PASTA:
        return std::make_unique<Pasta>(kcal, price);
    case Types::NONE:
		throw Exception("Exception");
    }
}