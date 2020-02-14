#!/usr/bin/env python3

"""
Look up words in macOS dictionary.

Modified from:

http://macscripter.net/viewtopic.php?id=26675
http://apple.stackexchange.com/questions/90040/look-up-a-word-in-dictionary-app-in-terminal
https://gist.github.com/lambdamusic/bdd56b25a5f547599f7f
"""


import sys

try:
    from DictionaryServices import DCSCopyTextDefinition
except ImportError:
    print("ERROR: Missing lib. $ pip install pyobjc-framework-CoreServices")
    sys.exit()

try:
    from colorama import Fore, Style
except ImportError:
    print("ERROR: Missing lib. $ pip install colorama")


def main():
    """
    define.py

    Access the default OSX dictionary
    """
    try:
        searchword = sys.argv[1]
    except IndexError:
        errmsg = 'You did not enter any terms to look up in the Dictionary.'
        print(errmsg)
        sys.exit()
    wordrange = (0, len(searchword))
    dictresult = DCSCopyTextDefinition(None, searchword, wordrange)
    if not dictresult:
        errmsg = "'%result' not found in Dictionary." % (searchword)
        print(errmsg.encode('utf-8'))
    else:
        result = dictresult.encode("utf-8")

        arrow = colorize("\n\n\xe2\x96\xb6 ", "red")
        result = result.replace(b'\xe2\x96\xb6', arrow)

        bullet = colorize(u'\n\u2022', "bold")
        result = result.replace(b'\xe2\x80\xa2', bullet)

        phrases_header = colorize("\n\nPHRASES\n", "bold")
        result = result.replace(b'PHRASES', phrases_header)

        derivatives_header = colorize("\n\nDERIVATIVES\n", "bold")
        result = result.replace(b'DERIVATIVES', derivatives_header)

        origin_header = colorize("\n\nORIGIN\n", "bold")
        result = result.replace(b'ORIGIN', origin_header)

        result = result.decode("utf-8")

        for part in ["noun", "verb", "adverb", "adjective"]:
            result = result.replace(f"{part} 1", f"\n{Fore.GREEN + part + Style.RESET_ALL}\n1")

        for num in range(2, 10):
            result = result.replace(f" {num} ", f"\n{num} ")

        print("\n", result)


def colorize(string, style=None):
    """
    Returns a colored string encoded as a sequence of bytes.
    """
    string = str(string)
    if style == "bold":
        string = Style.BRIGHT + string + Style.RESET_ALL
    elif style == "red":
        string = Fore.RED + string + Style.RESET_ALL
    return bytes(string, encoding="utf-8")


if __name__ == '__main__':
    main()
