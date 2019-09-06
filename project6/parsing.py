
class HackTranslationTable():
    PREDEFINED_SYMBOLS = {
            'R0':  '0',
            'R1':  '1',
            'R2':  '2',
            'R3':  '3',
            'R4':  '4',
            'R5':  '5',
            'R6':  '6',
            'R7':  '7',
            'R8':  '8',
            'R9':  '9',
            'R10':  '10',
            'R11': '11',
            'R12': '12',
            'R13': '13',
            'R14': '14',
            'R15': '15',
            'SCREEN': '16384',
            'SP': '0',
            'LCL': '1',
            'THIS': '3',
            'THAT': '4',
            'KBD': '24576',
            }
    JUMP_BITS = {
            'null': '000',
            'JGT': '001',
            'JEQ': '010',
            'JGE': '011',
            'JLT': '100',
            'JNE': '101',
            'JLE': '110',
            'JMP': '111',}
    DEST_BITS = {
            'null': '000',
            'M': '001',
            'D': '010',
            'A': '100',
            'MD': '011',
            'AM': '101',
            'AD': '110',
            'AMD': '111',}
    COMP_BITS = {
        '0': '0101010',
        '1': '0111111',
        '-1': '0111010',
        'D': '0001100',
        'A': '0110000',
        '!D': '0001101',
        '!A': '0110001',
        '-D': '0001111',
        '-A': '0110011',
        'D+1': '0011111',
        'A+1': '0110111',
        'D-1': '0001110',
        'A-1': '0110010',
        'D+A': '0000010',
        'D-A': '0010011',
        'A-D': '0000111',
        'D&A': '0000000',
        'D|A': '0010101',
        'M': '1110000',
        '!M': '1110001',
        '-M': '1110011',
        'M+1': '1110111',
        'M-1': '1110010',
        'D+M': '1000010',
        'D-M': '1010011',
        'M-D': '1000111',
        'D&M': '1000000',
        'D|M': '1010101',}

    def __init__(self):
        self.table = {}
        self.__create_symbol_table()

    def __create_symbol_table(self):
        pass

class ParseEngine():
    def __init__(self, fname: str):
        self.fname = fname
        self.hacktable = HackTranslationTable()

        # 1st pass -- remove all non-source lines of code
        self.source_only = self.__first_pass(self.fname)

    def __first_pass(self, fname: str) -> [str]:
        """Read file descriptor line-by-line, skipping lines that are either
        empty of begin with a comment character.
        """
        result = []
        with open(fname) as fd:
            for line in fd:
                # skip condition: comment character or line is empty, i.e. ''
                if line.startswith(('/', '*', '\n')) or not line:
                    continue
                result.append(line.strip())
        return [i.strip() for i in result]

    def __second_pass(self):
        pass
