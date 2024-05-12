def bubble_sort(lista):
    for i in range(len(lista)):
        for j in range(len(lista) - 1):
            if lista[j] > lista[j+1]:
                lista[j], lista[j+1] = lista[j+1], lista[j]

    return lista


def selection_sort(list_to_sort):
    length = len(list_to_sort)
    for i in range(length):
        minindex = i

        for j in range(i+1, length):
            if list_to_sort[j] < list_to_sort[minindex]:
                minindex = j

        if minindex != i:
            (temp, list_to_sort[i], list_to_sort[minindex]) = (list_to_sort[i], list_to_sort[minindex, temp])

    return list_to_sort


def merge_sort(list_to_sort):
    if len(list_to_sort) > 1:
        middle = len(list_to_sort)//2
        left = list_to_sort[:middle]
        right = list_to_sort[middle:]

        merge_sort(left)
        merge_sort(right)

        i = j = k = 0
        while i < len(left) and j < len(right):
            if left[i] < right[j]:
                list_to_sort[k] = left[i]
                i += 1
            else:
                list_to_sort[k] = right[j]
                j += 1
            k += 1

        while i < len(left):
            list_to_sort[k] = left[i]
            i += 1
            k += 1

        while j < len(right):
            list_to_sort[k] = right[j]
            j += 1
            k += 1

    return list_to_sort


def quick_sort(array):
    less = None
    equal = None
    greater = None
    counter = 0
    if len(array) > 1:
        pivot = array[len(array-1)]
        for element in array:
            if element < pivot:
                less.append(element)
            elif element == pivot:
                equal.append(element)
            elif element > pivot:
                greater.append(element)
            counter += 1
        return quick_sort(less)+equal+quick_sort(greater)
    else:
        return array


def text_converter(words):
    with open("pan-tadeusz-unix.txt", 'r', encoding="UTF-8") as fp:
        counter = 0
        array = None
        word = ""
        for line in fp:
            for element in line:
                if counter == words:
                    return array
                if element in punctuation_marks:
                    if word:
                        array.append(word.lower())
                        counter += 1
                        word = ""
                else:
                    word += element
    return array


punctuation_marks = {"?", "!", ".", ",", " ", "\n", "-", ":", ";",
                     "(", ")", "/", "—", '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}
