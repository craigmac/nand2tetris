"""packer/parse.py

Provides a Parser class to parse Hack assembly files.
"""

import os

class Parser():
    """
    @brief      class description

    @details    detailed description
    """
    def __init__(self, fname):
        """
        @brief      function description

        @details    detailed description

        @param      param

        @return     return type
        """
         self.fname = fname

    def strip_whitespace(self, line):
        """
        @brief      function description

        @details    detailed description

        @param      param

        @return     return type
        """
        raise NotImplemented

    def strip_comment(self, line):
        """
        @brief      function description

        @details    detailed description

        @param      param

        @return     return type
        """
        raise NotImplemented

    def

if __name__ == '__main__':
    print("parser.py should not be run directly. Please import the Parser class.")
