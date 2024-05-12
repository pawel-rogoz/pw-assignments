import gc
import sys
import time

from matplotlib import pyplot as plt
from BSTNode import BSTNode
from AVLNode import AVLTree
import random

sys.setrecursionlimit(10000)


def main():
    printing_trees()
    avl_creating_time = []
    bst_creating_time = []
    bst_searching_time = []
    avl_searching_time = []
    avl_delete_time = []
    bst_delete_time = []

    n = 1000
    while n <= 10000:
        time_avl = create_avl(n)
        avl_creating_time.append(time_avl)

        time_bst = create_bst(n)
        bst_creating_time.append(time_bst)

        avl_search = search_avl(n)
        avl_searching_time.append(avl_search)

        bst_search = search_bst(n)
        bst_searching_time.append(bst_search)

        time_avl_del = delete_avl(n)
        avl_delete_time.append(time_avl_del)

        time_bst_del = delete_bst(n)
        bst_delete_time.append(time_bst_del)

        n += 1000

    plot_search(avl_searching_time, bst_searching_time)
    plot_create(avl_creating_time, bst_creating_time)
    plot_delete(avl_delete_time, bst_delete_time)


def plot_search(avl, bst):
    x_axis = [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]
    plt.plot(x_axis, avl, label="AVL searching nodes time")
    plt.plot(x_axis, bst, label="BST searching nodes time")
    plt.xlabel("NUMBER OF NUMBERS")
    plt.ylabel("TIME")
    plt.legend()
    plt.title("Searching nodes in AVL and BST trees")
    plt.savefig("search_nodes.png")
    plt.show()


def plot_create(avl, bst):
    x_axis = [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]
    plt.plot(x_axis, avl, label="AVL creation time")
    plt.plot(x_axis, bst, label="BST creating time")
    plt.xlabel("NUMBER OF NUMBERS")
    plt.ylabel("TIME")
    plt.title("Creating AVL and BST trees for n numbers")
    plt.legend()
    plt.savefig("create_trees.png")
    plt.show()


def plot_delete(avl, bst):
    x_axis = [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]
    plt.plot(x_axis, avl, label="AVL deletion of n nodes time")
    plt.plot(x_axis, bst, label="BST deletion of n nodes time")
    plt.xlabel("NUMBER OF NUMBERS")
    plt.ylabel("TIME")
    plt.title("Deleting nodes from AVL and BST trees for n-numbers")
    plt.legend()
    plt.savefig("delete_nodes.png")
    plt.show()


def search_bst(size):
    bst = BSTNode()
    for i in range(size):
        bst.insert(numbers[i])
    gc_old = gc.isenabled()
    gc.disable()
    start = time.process_time()
    for i in range(size):
        bst.exists(numbers[i])
    stop = time.process_time()
    if gc_old:
        gc.enable()

    return stop-start


def search_avl(size):
    avl = AVLTree()
    root = None
    for i in range(size):
        root = avl.insert_node(root, numbers[i])
    gc_old = gc.isenabled()
    gc.disable()
    start = time.process_time()
    for i in range(size):
        avl.exists(numbers[i], root)
    stop = time.process_time()
    if gc_old:
        gc.enable()

    return stop-start


def delete_bst(size):
    bst = BSTNode()
    for i in range(size):
        bst.insert(numbers[i])
    gc_old = gc.isenabled()
    gc.disable()
    start = time.process_time()
    for i in range(size):
        bst.delete(numbers[i])
    stop = time.process_time()
    if gc_old:
        gc.enable()

    return stop-start


def delete_avl(size):
    avl = AVLTree()
    root = None
    for i in range(size):
        root = avl.insert_node(root, numbers[i])
    gc_old = gc.isenabled()
    gc.disable()
    start = time.process_time()
    for i in range(size):
        root = avl.delete_node(root, numbers[i])
    stop = time.process_time()
    if gc_old:
        gc.enable()

    return stop-start


def create_bst(size):
    gc_old = gc.isenabled()
    gc.disable()
    start = time.process_time()
    bst = BSTNode()
    for i in range(size):
        bst.insert(numbers[i])
    stop = time.process_time()
    if gc_old:
        gc.enable()

    return stop-start


def create_avl(size):
    gc_old = gc.isenabled()
    gc.disable()
    start = time.process_time()
    avl = AVLTree()
    root = None
    for i in range(size):
        root = avl.insert_node(root, numbers[i])
    stop = time.process_time()
    if gc_old:
        gc.enable()

    return stop-start


def printing_trees():
    numbers = generate_numbers(20)
    print(numbers)
    root = None
    myTree = AVLTree()
    bst = BSTNode()
    for num in numbers:
        bst.insert(num)
        root = myTree.insert_node(root, num)
    print("BST TREE:")
    bst.print_helper(bst, "", True)
    myTree = AVLTree()
    print("AVL TREE:")
    myTree.print_helper(root, "", True)


def generate_numbers(n=10000):
    numbers = random.sample(range(1, 30000), n)
    numbers.sort()
    middle = len(numbers) // 2
    small = numbers[:middle]
    small.reverse()
    big = numbers[middle:]
    numbers = []
    for i in range(middle):
        numbers.append(big[i])
        numbers.append(small[i])
    return numbers


if __name__ == "__main__":
    numbers = generate_numbers(10000)
    main()
