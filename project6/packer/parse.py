"""packer/parse.py

Provides a Parser class to parse Hack assembly files.
"""

import os
import itertools
import string


class Parser():
    def __init__(self, fname: str) -> None:
        self.fname = fname
        self.fraw = []

        ## TODO: add try/except clause here and test
        with open(fname) as f:
            self.fraw = f.readlines()

        f.close()  # no harm doing this

        print(self.fraw)
        self.strip_whitespace(self.fraw)

    def strip_whitespaces(self, line: str) -> str:
        return line.strip()

    def strip_comment(self, line: str) -> str:
        pass


if __name__ == '__main__':
    print("parser.py should not be run directly. Please import the Parser class.")
