# Authors: Zuzanna Damszel, Paweł Rogóż
# Version: 1.0.2

code = {'A': '.-',
        'B': '-...',
        'C': '-.-.',
        'D': '-..',
        'E': '.',
        'F': '..-.',
        'G': '--.',
        'H': '....',
        'I': '..',
        'J': '.---',
        'K': '-.-',
        'L': '.-..',
        'M': '--',
        'N': '-.',
        'O': '---',
        'P': '.--.',
        'Q': '--.-',
        'R': '.-.',
        'S': '...',
        'T': '-',
        'U': '..-',
        'V': '...-',
        'W': '.--',
        'X': '-..-',
        'Y': '-.--',
        'Z': '--..',
        '\n': '\n',
        }


def convert(fp):
    morse_string = ""
    a = 0
    for line in fp:
        for letter in line:
            if (letter.upper() not in code.keys()):
                if (letter.upper() == ' '):
                    a += 1
                continue
            elif (letter.upper() in code.keys()):
                if (a > 0):
                    a = 0
                    morse_string += '/ '
                morse_string += code[letter.upper()]
                if (letter.upper() != '\n'):
                    morse_string += ' '
    print(morse_string)
    return morse_string


with open("words_morse.txt", 'r') as fp:
    convert(fp)
