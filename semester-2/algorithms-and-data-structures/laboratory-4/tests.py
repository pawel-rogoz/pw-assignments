from finder import naiveFind, KMPFind, fillLSPList
import pytest

def test_naive_regular():
    string = "abcdabcd"
    text = "ab"
    assert naiveFind(string, text)[0] == 0
    assert naiveFind(string, text)[1] == 4
    assert len(naiveFind(string, text)) == 2

def test_naive_not_matching():
    string = "bbbbbbb"
    text = "aa"
    assert len(naiveFind(string, text)) == 0

def test_naive_string_bigger():
    string = "ab"
    text = "abc"
    with pytest.raises(ValueError):
        naiveFind(string, text)

def test_kmp_regular():
    string = "abcdabcd"
    text = "ab"
    assert KMPFind(string, text)[0] == 0
    assert KMPFind(string, text)[1] == 4
    assert len(KMPFind(string, text)) == 2    

def test_kmp_not_matching():
    string = "bbbbbbb"
    text = "aa"
    assert len(KMPFind(string, text)) == 0

def test_kmp_string_bigger():
    string = "ab"
    text = "abc"
    with pytest.raises(ValueError):
        KMPFind(string, text)
