from finder import naiveFind, KMPFind, KRFind
import gc
import time
from matplotlib import pyplot as plt
from statistics import mean


def read_from_file(number):
    with open("tadek.txt", 'r') as fp:
        list_of_words = [word for line in fp for word in line.split()]
    return list_of_words[:number]


def search_naive():
    list_of_search_times_final = []
    num = 100
    while num <= 1000:
        list_of_word_to_find_curr = list_of_word_to_find[:num]
        list_of_search_times = []
        for i in range(5):
            with open("tadek.txt", 'r') as fp:
                file = fp.read()
                gc_old = gc.isenabled()
                gc.disable()
                start = time.process_time()
                for word in list_of_word_to_find_curr:
                    naiveFind(word, file)
                stop = time.process_time()
                if gc_old:
                    gc.enable()
                list_of_search_times.append(stop-start)
        num += 100
        list_of_search_times_final.append(mean(list_of_search_times))
        print(num)
    return list_of_search_times_final


def search_kmp():
    list_of_search_times_final = []
    num = 100
    while num <= 1000:
        list_of_word_to_find_curr = list_of_word_to_find[:num]
        list_of_search_times = []
        for i in range(5):
            with open("tadek.txt", 'r') as fp:
                file = fp.read()
                gc_old = gc.isenabled()
                gc.disable()
                start = time.process_time()
                for word in list_of_word_to_find_curr:
                    KMPFind(word, file)
                stop = time.process_time()
                if gc_old:
                    gc.enable()
                list_of_search_times.append(stop-start)
        num += 100
        list_of_search_times_final.append(mean(list_of_search_times))
        print(num)
    return list_of_search_times_final


def search_kr():
    list_of_search_times_final = []
    num = 100
    while num <= 1000:
        list_of_word_to_find_curr = list_of_word_to_find[:num]
        list_of_search_times = []
        for i in range(5):
            with open("tadek.txt", 'r') as fp:
                file = fp.read()
                gc_old = gc.isenabled()
                gc.disable()
                start = time.process_time()
                for word in list_of_word_to_find_curr:
                    KRFind(word, file)
                stop = time.process_time()
                if gc_old:
                    gc.enable()
                list_of_search_times.append(stop-start)
        num += 100
        list_of_search_times_final.append(mean(list_of_search_times))
        print(num)
    return list_of_search_times_final


def plotter(naive, kmp, kr):
    x_axis = [100, 200, 300, 400, 500,
              600, 700, 800, 900, 1000]
    plt.plot(x_axis, naive, label="Naive algorithm")
    plt.plot(x_axis, kmp, label="KMP algorithm")
    plt.plot(x_axis, kr, label="KR algorithm")
    plt.xlabel("Number of words searched")
    plt.ylabel("Time")
    plt.legend()
    plt.title("Searching words")
    plt.savefig("searching.png")
    plt.show()


def main():
    times_naive = search_naive()
    times_kmp = search_kmp()
    times_kr = search_kr()
    plotter(times_naive, times_kmp, times_kr)


if __name__ == "__main__":
    list_of_word_to_find = read_from_file(1000)
    main()
