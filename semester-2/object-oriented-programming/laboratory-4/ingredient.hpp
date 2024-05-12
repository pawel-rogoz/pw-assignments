#ifndef INGREDIENT_H
#define INGREDIENT_H

class Ingredient
{
protected:
    unsigned int kcal;
    float price;
public:
    Ingredient(unsigned int kcal, float price);
    void setPrice(const float price);
    void setKcal(const unsigned int kcal);
    float getPrice() const;
    unsigned int getKcal() const;
    virtual ~Ingredient(){};
    virtual void changePriceByPercent(int percent) = 0;
};

class Diary : public Ingredient
{
public:
    Diary(unsigned int kcal, float price);
    virtual ~Diary(){};
    virtual void changePriceByPercent(int percent) override;
};

class Meat : public Ingredient
{
public:
    Meat(unsigned int kcal, float price);
    virtual ~Meat(){};
    virtual void changePriceByPercent(int percent) override;
};

class Vegetable : public Ingredient
{
public:
    Vegetable(unsigned int kcal, float price);
    virtual ~Vegetable(){};
    virtual void changePriceByPercent(int percent) override;
};

class Pasta : public Ingredient
{
public:
    Pasta(unsigned int kcal, float price);
    virtual ~Pasta(){};
    virtual void changePriceByPercent(int percent) override;
};

#endif