from random import random
from statistics import mean
import gc
import sys
import time
from matplotlib import pyplot as plt
from numbers_generator import numbersGenerator
from heap import Heap


# create heap
def main_create_heap(n_children):
    random_list = numbersGenerator(100000)
    # for each case (10000, 20000, ..., 100000)
    # creating heaps will happen 10 times
    # to obtain better average value

    i = 10000
    heap_create_time_final = []
    while i <= 100000:
        random_list_n = random_list[:i]
        heap_create_time = []
        for j in range(10):
            time_create = create_heap(n_children, random_list_n)
            heap_create_time.append(time_create)
        average_time = mean(heap_create_time)
        heap_create_time_final.append(average_time)
        i += 10000

    return heap_create_time_final


def create_heap(n_children, list_numbers):
    gc_old = gc.isenabled()
    gc.disable()
    start = time.process_time()
    heap = Heap(n_children)
    for element in list_numbers:
        heap.push(element)
    stop = time.process_time()
    if gc_old:
        gc.enable()
    return stop - start


def plotter_create(time2, time3, time4):
    x_axis = [10000, 20000, 30000, 40000, 50000,
              60000, 70000, 80000, 90000, 100000]
    plt.plot(x_axis, time2, label="Two-children heap")
    plt.plot(x_axis, time3, label="Three-children heap")
    plt.plot(x_axis, time4, label="Four-children heap")
    plt.xlabel("Number of first elements in a base list of numbers")
    plt.ylabel("Time")
    plt.legend()
    plt.title("Creating heaps")
    plt.savefig("create_heaps.png")
    plt.show()


def main_delete_root(n_children):
    random_list = numbersGenerator(100000)
    i = 10000
    root_delete_time_final = []
    while i <= 100000:
        i += 10000
        heap = Heap(n_children)
        for elem in random_list:
            heap.push(elem)
        root_delete_time = []
        for j in range(10):

            time_deletion = delete_root(j, heap)
            root_delete_time.append(time_deletion)
        root_delete_time_final.append(mean(root_delete_time))

        # if i == 10:
        #     break

    return root_delete_time_final


def delete_root(iter, heap):
    gc_old = gc.isenabled()
    gc.disable()
    start = time.process_time()
    for i in range(iter):
        heap.pop()
    stop = time.process_time()
    if gc_old:
        gc.enable()
    return stop - start


def plotter_delete(time2, time3, time4):
    x_axis = [10000, 20000, 30000, 40000, 50000,
              60000, 70000, 80000, 90000, 100000]
    plt.plot(x_axis, time2, label="Two-children heap")
    plt.plot(x_axis, time3, label="Three-children heap")
    plt.plot(x_axis, time4, label="Four-children heap")
    plt.xlabel("Number of deleted roots")
    plt.ylabel("Time")
    plt.legend()
    plt.title("Deleting roots")
    plt.savefig("delete_roots.png")
    plt.show()


def main1():
    random_list = numbersGenerator(15)
    heap = Heap(2)
    for elem in random_list:
        heap.push(elem)
    print(heap.heapPrinter())
    for i in range(1):
        heap.pop()
    print(heap.heapPrinter())


if __name__ == "__main__":
    # time_create2 = main_create_heap(2)
    # time_create3 = main_create_heap(3)
    # time_create4 = main_create_heap(4)

    # plotter_create(time_create2, time_create3, time_create4)

    time_delete2 = main_delete_root(2)
    time_delete3 = main_delete_root(3)
    time_delete4 = main_delete_root(4)

    plotter_delete(time_delete2, time_delete3, time_delete4)

    # main1()
