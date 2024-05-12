#define CATCH_CONFIG_MAIN
#include "catch.hpp"
#include "classes.h"

TEST_CASE("ShoeNameTest") {
    Shoe shoe("Nike", 2.5);

    REQUIRE(shoe.GetName() == "Nike");
}

TEST_CASE("ShoeWeightTest") {
    Shoe shoe("Nike", 2.5)

    REQUIRE(shoe.GetWeight() == 2.5);
}

TEST_CASE("MaxOccupancyTest") {
    Box box(1, 1, 1, 3.8, "1zFO");

    REQUIRE(box.GetMaxOccupancy() == 3.8);
}

TEST_CASE("VolumeTest") {
    Box box(10, 10, 10, 3.8, "1zFO");

    REQUIRE(box.GetVolume() == 1000);
}

TEST_CASE("TrackingNumberTest") {
    Box box(10, 10, 10, 3.8, "1zFO");

    REQUIRE(box.GetTrackingNumber() == "1zFO");
}

TEST_CASE("IsFullTest") {
    Box box(10, 10, 10, 3.8, "1zFO");

    Shoe shoe("Adidas", 2.3);

    box.SetShoe(shoe);

    REQUIRE(box.GetIsFull() == true);
}

TEST_CASE("InsideShoeNameTest") {
    Box box(10, 10, 10, 3.8, "1zFO");

    Shoe shoe("Adidas", 2.3);

    box.SetShoe(shoe);

    REQUIRE(box.GetInsideShoeName() == "Adidas");
}

TEST_CASE("TooHeavyShoeTest") {
    Box box(10, 10, 10, 3.8, "1zFO");

    Shoe shoe("Adidas", 3.9);

    Shoe shoe2("Nike", 1.3);

    box.SetShoe(shoe);
    REQUIRE(box.GetIsFull() == false);

    box.SetShoe(shoe2);
    REQUIRE(box.GetIsFull() == true);
}