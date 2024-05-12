from numpy import number
from pyrfc3339 import generate
from heap import Heap
from numbers_generator import numbersGenerator

list_of_numbers = numbersGenerator(100)


def test_peek_is_max2():
    heap = Heap(2)
    for i in range(100):
        heap.push(list_of_numbers[i])

    assert max(list_of_numbers) == heap.peek()


def test_peek_is_max3():
    heap = Heap(4)
    for i in range(100):
        heap.push(list_of_numbers[i])

    assert max(list_of_numbers) == heap.peek()


def test_peek_is_max4():
    heap = Heap(4)
    for i in range(100):
        heap.push(list_of_numbers[i])

    assert max(list_of_numbers) == heap.peek()
