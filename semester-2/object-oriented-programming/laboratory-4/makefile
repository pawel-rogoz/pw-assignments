# CXX = g++
# CXX_FLAGS = -Wall -Wextra -pedantic -Werror -std=c++20


# HEADERS := ./headers
# BUILD := ./build
# ALL_O := $(wildcard *.o)

# main.exe: dish.o ingredient.o
# 	$(CXX) $(CXX_FLAGS) $(ALL_O) -o main

# tests.exe: tests.o dish.o ingredient.o
# 	$(CXX) $(CXX_FLAGS) $(ALL_O) -o tests.exe

# main.o: main.cpp dish.hpp ingredient.hpp
# 	$(CXX) $(CXX_FLAGS) -c $< -o $@

# dish.o: dish.cpp dish.hpp
# 	$(CXX) $(CXX_FLAGS) -c $< -o $@

# tests.o: tests.cpp dish.hpp ingredient.hpp
# 	$(CXX) $(CXX_FLAGS) -c $< -o $@

# clean:
# 	rm build/*.o

final:
	g++ tests.cpp dish.cpp ingredient.cpp -Wall -Wextra -pedantic -Werror -o final