from sorting import merge_sort, bubble_sort, selection_sort, quick_sort, text_converter


def test_bubble1():
    with open("pan-tadeusz-unix.txt", 'r', encoding="UTF-8") as fp:
        assert bubble_sort(text_converter(10)) == [
            'adam', 'czyli', 'isbn', 'litwie', 'mickiewicz', 'na', 'ostatni', 'pan', 'tadeusz', 'zajazd']


def test_bubble2():
    with open("pan-tadeusz-unix.txt", 'r', encoding="UTF-8") as fp:
        assert bubble_sort(text_converter(20)) == ['adam', 'czyli', 'gospodarstwo', 'isbn', 'księga', 'litwie', 'mickiewicz', 'na',
                                                   'ostatni', 'pan', 'panicza', 'pierwsza', 'pierwsze', 'pokoiku', 'powrót', 'się', 'spotkanie', 'tadeusz', 'w', 'zajazd']


def test_selection1():
    with open("pan-tadeusz-unix.txt", 'r', encoding="UTF-8") as fp:
        assert selection_sort(text_converter(10)) == [
            'adam', 'czyli', 'isbn', 'litwie', 'mickiewicz', 'na', 'ostatni', 'pan', 'tadeusz', 'zajazd']


def test_selection2():
    with open("pan-tadeusz-unix.txt", 'r', encoding="UTF-8") as fp:
        assert selection_sort(text_converter(20)) == ['adam', 'czyli', 'gospodarstwo', 'isbn', 'księga', 'litwie', 'mickiewicz', 'na',
                                                      'ostatni', 'pan', 'panicza', 'pierwsza', 'pierwsze', 'pokoiku', 'powrót', 'się', 'spotkanie', 'tadeusz', 'w', 'zajazd']


def test_merge2():
    with open("pan-tadeusz-unix.txt", 'r', encoding="UTF-8") as fp:
        assert merge_sort(text_converter(20)) == ['adam', 'czyli', 'gospodarstwo', 'isbn', 'księga', 'litwie', 'mickiewicz', 'na',
                                                  'ostatni', 'pan', 'panicza', 'pierwsza', 'pierwsze', 'pokoiku', 'powrót', 'się', 'spotkanie', 'tadeusz', 'w', 'zajazd']


def test_merge1():
    with open("pan-tadeusz-unix.txt", 'r', encoding="UTF-8") as fp:
        assert merge_sort(text_converter(10)) == [
            'adam', 'czyli', 'isbn', 'litwie', 'mickiewicz', 'na', 'ostatni', 'pan', 'tadeusz', 'zajazd']


def test_quick1():
    with open("pan-tadeusz-unix.txt", 'r', encoding="UTF-8") as fp:
        array = text_converter(10)
        assert quick_sort(array) == [
            'adam', 'czyli', 'isbn', 'litwie', 'mickiewicz', 'na', 'ostatni', 'pan', 'tadeusz', 'zajazd']


def test_quick2():
    with open("pan-tadeusz-unix.txt", 'r', encoding="UTF-8") as fp:
        array = text_converter(20)
        assert quick_sort(array) == ['adam', 'czyli', 'gospodarstwo', 'isbn', 'księga', 'litwie', 'mickiewicz', 'na',
                                                      'ostatni', 'pan', 'panicza', 'pierwsza', 'pierwsze', 'pokoiku', 'powrót', 'się', 'spotkanie', 'tadeusz', 'w', 'zajazd']
