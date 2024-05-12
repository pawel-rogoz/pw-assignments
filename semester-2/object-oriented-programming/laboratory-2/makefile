main.exe: restaurant.o dish.o
	g++ -std=c++11 main.cpp

tests.exe: tests.o restaurant.o dish.o
	g++ -std=c++11 -o tests.exe

main.o: main.cpp restaurant.hpp dish.hpp
	g++ -std=c++11 -c main.cpp

restaurant.o: restaurant.cpp restaurant.hpp dish.hpp
	g++ -std=c++11 -c restaurant.cpp

dish.o: dish.cpp dish.hpp
	g++ -std=c++11 -c dish.cpp

tests.o: tests.cpp restaurant.hpp dish.hpp
	g++ -std=c++11 -c tests.cpp