from sorting import merge_sort, bubble_sort, selection_sort, quick_sort, text_converter
import pytest


@pytest.fixture
def data():
    x = text_converter(10000)
    return x


def test_bubble(benchmark, data):
    benchmark(bubble_sort, data)


def test_selection(benchmark, data):
    benchmark(selection_sort, data)


def test_merge(benchmark, data):
    benchmark(merge_sort, data)


def test_quick(benchmark, data):
    benchmark(quick_sort, data)
