CXX = g++
CXX_FLAGS = -Wall -Wextra -pedantic -Werror -fsanitize=undefined -std=c++20


HEADERS := ./headers
BUILD := ./build
ALL_O := $(wildcard *.o)

main.exe: restaurant.o dish.o
	$(CXX) $(CXX_FLAGS) $(ALL_O) -o main
	# g++ -std=c++20 main.cpp

tests.exe: tests.o restaurant.o dish.o
	$(CXX) $(CXX_FLAGS) $(ALL_O) -o tests.exe
	# g++ -std=c++20 tests.o restaurant.o dish.o -o tests.exe

main.o: main.cpp restaurant.hpp dish.hpp
	$(CXX) $(CXX_FLAGS) -c $< -o $@
	# g++ -std=c++20 -c main.cpp

restaurant.o: restaurant.cpp restaurant.hpp dish.hpp
	$(CXX) $(CXX_FLAGS) -c $< -o $@
	# g++ -std=c++20 -c restaurant.cpp

dish.o: dish.cpp dish.hpp
	$(CXX) $(CXX_FLAGS) -c $< -o $@
	# g++ -std=c++20 -c dish.cpp

tests.o: tests.cpp restaurant.hpp dish.hpp
	$(CXX) $(CXX_FLAGS) -c $< -o $@
	# g++ -std=c++20 -c tests.cpp

clean:
	rm build/*.o
