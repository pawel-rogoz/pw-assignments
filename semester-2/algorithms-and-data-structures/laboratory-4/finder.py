
def naiveFind(string, text):
    string_length = len(string)  # szuakny napis
    text_length = len(text)  # text
    list_of_index = []
    if string_length > text_length:
        raise ValueError(
            "Length of string cannot be greater than length of text")
    for text_index in range(text_length):
        matching = 0
        temp_text_index = text_index
        if (text_index + string_length) > text_length:
            break
        for str_index in range(string_length):
            if string[str_index] == text[temp_text_index]:
                temp_text_index += 1
                matching += 1
            else:
                break
            if matching == string_length:
                list_of_index.append(temp_text_index - matching)
    return list_of_index


def KMPFind(string, text):
    string_length = len(string)
    text_length = len(text)

    if string_length > text_length:
        raise ValueError(
            "Length of string cannot be greater than length of text")

    lps_list = [0] * string_length
    list_of_index = []

    fillLSPList(string, string_length, lps_list)

    text_index = 0
    string_index = 0

    while text_index < text_length:
        if text[text_index] == string[string_index]:
            text_index += 1
            string_index += 1
        if string_index == string_length:
            list_of_index.append(text_index - string_length)
            string_index = lps_list[string_index - 1]

        elif string_index < string_length and text[text_index] != string[string_index]:
            if string_index != 0:
                string_index = lps_list[string_index - 1]
            else:
                text_index += 1

    return list_of_index


def fillLSPList(string, string_length, lps_list):
    length = 0

    lps_list[0] = 0
    index = 1

    while index < string_length:
        if string[index] == string[length]:
            length += 1
            lps_list[index] = length
            index += 1
        else:
            if length != 0:
                length = lps_list[length - 1]
            else:
                lps_list[index] = 0
                index += 1


d = 256
q = 269


def KRFind(pattern, text):
    m = len(pattern)
    n = len(text)
    p = 0
    t = 0
    h = 1
    i = 0
    j = 0

    for i in range(m-1):
        h = (h*d) % q

    for i in range(m):
        p = (d*p + ord(pattern[i])) % q
        t = (d*t + ord(text[i])) % q

    for i in range(n-m+1):
        if p == t:
            for j in range(m):
                if text[i+j] != pattern[j]:
                    break
