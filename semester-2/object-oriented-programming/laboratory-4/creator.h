#ifndef CREATOR_H
#define CREATOR_H
#include <memory>
#include <exception>
#include <string>
#include "ingredient.hpp"

enum class Types
{
	NONE,
	DIARY,
	MEAT,
	VEGETABLE,
	PASTA
};

class Creator
{
public:
	std::unique_ptr<Ingredient> create(const Types &type, unsigned int kcal, float price);
};

class Exception : public std::exception
{
	std::string message;

public:
	Exception(const std::string &message) : message(message){};
	// const char *what() const
	// {
	// 	return &message[0];
	// }
	std::string getMess()
	{
		return message;
	};
};

#endif
