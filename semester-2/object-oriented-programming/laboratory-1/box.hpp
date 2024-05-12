#ifndef BOX_H
#define BOX_H

#include <string>

using namespace std;

class Box {
public:
    Box ();
    Box (int width, int length, int height, float max_occupancy, string tracking_number);

    int GetVolume();

    bool GetIsFull();

    float GetMaxOccupancy();

    void SetShoe(Shoe shoe);

    string GetTrackingNumber();

    string GetInsideShoeName();
private:
    int width;
    int length;
    int height;
    float max_occupancy;
    string tracking_number;
    Shoe inside_shoe;
    bool isFull;
};

#endif