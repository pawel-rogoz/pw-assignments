main.exe: main.o box.o shoe.o 
	g++ main.o box.o shoe.o

main.o: main.cpp box.hpp shoe.hpp
	g++ -c main.cpp

box.o: box.cpp box.hpp shoe.hpp
	g++ -c box.cpp

shoe.o: shoe.cpp shoe.hpp
	g++ -c shoe.cpp