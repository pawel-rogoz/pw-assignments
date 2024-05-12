#include <iostream>
#include <cstdlib>

using namespace std;

class Shoe {
private:
    string name;
    float weight;
public:
    Shoe (string name, float weight) {
        this->name = name;
        this->weight = weight;
    }

    Shoe () {
    }

    string GetName();
    float GetWeight();
};

class Box {
private:
    int width;
    int length;
    int height;
    float max_occupancy;
    string tracking_number;
    Shoe inside_shoe;
    bool isFull;
public:
    Box (int width, int length, int height, float max_occupancy, string tracking_number) {
        this->width = width;
        this->length = length;
        this->height = height;
        this->max_occupancy = max_occupancy;
        this->tracking_number = tracking_number;
    }

    Box () {
    }

    int GetVolume();

    bool GetIsFull();

    float GetMaxOccupancy();

    void SetShoe(Shoe shoe);

    string GetTrackingNumber();

    string GetInsideShoeName();
};

int Box::GetVolume() {
    return this->height * this->width * this->length;
};

void Box::SetShoe(Shoe shoe) {
    float weight = shoe.GetWeight();
    float occupancy = this->max_occupancy;
    if (weight <= occupancy){
        this->inside_shoe = shoe;
        this->isFull = true;
    }
};

float Box::GetMaxOccupancy() {
    return this->max_occupancy;
};

string Box::GetTrackingNumber() {
    return this->tracking_number;
};

string Box::GetInsideShoeName() {
    string name = this->inside_shoe.GetName();
    return name;
};

bool Box::GetIsFull() {
    return this->isFull;
};

float Shoe::GetWeight() {
    return this->weight;
};

string Shoe::GetName() {
    return this->name;
};