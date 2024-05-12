#include <iostream>
#include <cstdlib>
#include "classes.h"

using namespace std;

int main () {
    Box box (10, 10, 10, 2.5, "1ZF8");

    Shoe shoe("Nike", 12.0);

    box.SetShoe(shoe);

    cout << box.GetMaxOccupancy() << endl;
    cout << box.GetVolume() << endl;
    if (box.GetInsideShoeName() != "") {
        cout << box.GetInsideShoeName() << endl;
    }
    else {
        cout << "There is no shoe in this box" << endl;
    }
    cout << box.GetIsFull() << endl;
}