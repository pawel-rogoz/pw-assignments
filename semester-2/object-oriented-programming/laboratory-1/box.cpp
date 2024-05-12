#include <string>

#include "box.hpp"

Box::Box(){}

Box::Box(int width, int length, int height, float max_occupancy, string tracking_number)
{
    this->width = width;
    this->length = length;
    this->height = height;
    this->max_occupancy = max_occupancy;
    this->tracking_number = tracking_number;
}

string Box::GetInsideShoeName()
{
    string name = this->inside_shoe.GetName();
    return name;
}

int Box::GetVolume() {
    return this->height * this->width * this->length;
}

void Box::SetShoe(Shoe shoe) {
    float weight = shoe.GetWeight();
    float occupancy = this->max_occupancy;
    if (weight <= occupancy){
        this->inside_shoe = shoe;
        this->isFull = true;
    }
}

float Box::GetMaxOccupancy() {
    return this->max_occupancy;
}

string Box::GetTrackingNumber() {
    return this->tracking_number;
}

bool Box::GetIsFull() {
    return this->isFull;
}