from morse2 import convert


def test_letters_only(benchmark):
    text = "Ala ma kota\na kot ma Ale"
    assert convert(
        text) == ".- .-.. .- / -- .- / -.- --- - .- \n.- / -.- --- - / -- .- / .- .-.. . "
    assert benchmark(
        convert, text) == ".- .-.. .- / -- .- / -.- --- - .- \n.- / -.- --- - / -- .- / .- .-.. . "


def test_small_big_letters(benchmark):
    text = "Ala ma kOtA\nKoT mA aLe"
    assert convert(
        text) == ".- .-.. .- / -- .- / -.- --- - .- \n-.- --- - / -- .- / .- .-.. . "
    assert benchmark(
        convert, text) == ".- .-.. .- / -- .- / -.- --- - .- \n-.- --- - / -- .- / .- .-.. . "


def test_numbers(benchmark):
    text = "Ala ma kOtA\nKoT mA aLe\nab24c 4 e"
    assert convert(
        text) == ".- .-.. .- / -- .- / -.- --- - .- \n-.- --- - / -- .- / .- .-.. . \n.- -... -.-. / . "
    assert benchmark(
        convert, text) == ".- .-.. .- / -- .- / -.- --- - .- \n-.- --- - / -- .- / .- .-.. . \n.- -... -.-. / . "


def test_numbers_special_signs(benchmark):
    text = "KoT mA aLe\n!@ae ae A3=]E"
    assert convert(
        text) == "-.- --- - / -- .- / .- .-.. . \n.- . / .- . / .- . "
    assert benchmark(
        convert, text) == "-.- --- - / -- .- / .- .-.. . \n.- . / .- . / .- . "
