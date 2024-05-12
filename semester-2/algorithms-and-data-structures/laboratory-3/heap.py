import typing
from abc import ABC, abstractmethod
from typing import List

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
        pass

    def __len__(self) -> int:
        return len(self.get_raw_data())

    @abstractmethod
    def peek(self) -> C:
        """Get the topmost element without changing the heap."""

    @abstractmethod
    def push(self, value: C):
        """Add an element to the heap."""

    @abstractmethod
    def pop(self) -> C:
        """Remove the topmost element from the heap and return it."""

    @abstractmethod
    def get_raw_data(self) -> List[C]:
        """Get the underlying data storage."""


class Heap(AbstractHeap):
    def __init__(self, num_children: int) -> None:
        self.num_children = num_children
        self._heap_list = []

    def peek(self) -> C:
        """Get the topmost element without changing the heap."""
        return self.get_raw_data()[0]  # first element of the list is the topmost element

    def push(self, value: C):
        """Add an element to the heap."""
        self._heap_list.append(value)  # add element to the last position
        heap = self._heap_list
        size = len(heap) - 1
        while True:
            # looking who is the parent
            parent_number = int((max((size-1), 0) / self.num_children) // 1)
            parent = heap[parent_number]
            if parent < value:  # if given value is bigger than a parent, change it
                temp = parent
                heap[parent_number] = value
                heap[size] = temp
                size = parent_number
            else:
                break  # if it is not bigger, parent's parent will be not too, so break the loop
        self._heap_list = heap

    def pop(self) -> C:
        """Remove the topmost element from the heap and return it."""
        heap = self._heap_list
        if len(heap) == 0:
            return
        size = len(heap) - 1
        # last element of the list is changed with the topmost one
        new_top = heap[size]
        peek = heap[0]
        heap[0] = new_top
        # deleting last element, because it is now the first one
        del(heap[size])
        curr_number = 0
        while True:
            dict = {}
            for num in range(self.num_children):
                # checking if one of children has bigger value than parent
                if (self.num_children * curr_number + num) < size-1:
                    place = self.num_children * curr_number + num + 1
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

    def get_raw_data(self) -> List[C]:
        """Get the underlying data storage."""
        return self._heap_list

    def heapPrinter(self):
        heap = self._heap_list
        size = len(heap)
        num_children = self.num_children
        counter = 0
        new_line_counter = num_children
        if size == 0:
            print("There is no element in this heap")
        else:
            word = f"topmost: {heap[0]}\n"
            for element in range(1, len(heap)):
                parent_number = int(((element-1) / self.num_children) // 1)
                if (counter % num_children) == 0:
                    word += f"parent: {heap[parent_number]} : "
                word += f"{heap[element]}, "
                counter += 1
                if (counter % num_children) == 0:
                    word += "   "
                if counter == new_line_counter:
                    word += "\n"
                    new_line_counter *= num_children
                    counter = 0
        return word
