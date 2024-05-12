from random import sample


def numbersGenerator(quantity):
    numbers = sample(range(0, 300000), quantity)
    # numbers.sort(reverse=True)
    # print(numbers)
    return numbers
