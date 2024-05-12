import typing
from abc import ABC, abstractmethod
from typing import List
from numbers_generator import numbersGenerator

from typing_extensions import Protocol

C = typing.TypeVar("C", bound="Comparable")


class Comparable(Protocol):
    @abstractmethod
    def __lt__(self: C, other: C) -> bool:
        pass

    @abstractmethod
    def __gt__(self: C, other: C) -> bool:
        pass


class AbstractHeap(ABC):
    def __init__(self, num_children: int) -> None:
        self.num_children = num_children
        self._heap_list = None

    def __len__(self) -> int:
        return len(self.get_raw_data())

    @abstractmethod
    def peek(self) -> C:
        """Get the topmost element without changing the heap."""
        return self.get_raw_data()[0]  # first element of the list is the topmost element

    @abstractmethod
    def push(self, value: C):
        """Add an element to the heap."""
        self._heap_list.append(value)  # add element to the last position
        heap = self._heap_list
        size = len(heap) - 1
        while True:
            # looking who is the parent
            parent_number = ((size-1) / self.num_children) // 1
            parent = heap[parent_number]
            if parent < value:  # if given value is bigger than a parent, change it
                temp = parent
                heap[parent_number] = value
                heap[size] = temp
                size = parent_number
            else:
                break  # if it is not bigger, parent's parent will be not too, so break the loop
        self._heap_list = heap

    @abstractmethod
    def pop(self) -> C:
        """Remove the topmost element from the heap and return it."""
        heap = self._heap_list
        size = len(heap)
        # last element of the list is changed with the topmost one
        new_top = heap[size-1]
        peek = heap[0]
        heap[0] = new_top
        # deleting last element, because it is now the first one
        del(heap[size-1])
        curr_number = 0
        while True:
            dict = {}
            for num in range(self.num_children):
                # checking if one of children has bigger value than parent
                if (self.num_children * curr_number + num) < size:
                    place = self.num_children * curr_number + num - 1
                    value = heap[place]
                    dict[value] = place
            if len(dict.keys()) == 0:
                break
            values = dict.keys()
            biggest = max(values)
            index = dict[biggest]
            # if the biggest value from children is bigger than parent, change it
            if biggest > heap[curr_number]:
                temp = heap[curr_number]
                heap[curr_number] = biggest
                heap[index] = temp
                curr_number = index
            else:
                break
        self._heap_list = heap
        return peek

    @abstractmethod
    def get_raw_data(self) -> List[C]:
        """Get the underlying data storage."""
        return self._heap_list
