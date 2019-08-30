# Week 6 Notes

# Unit 6.1: Assembly Languages and Assemblers

Assembly to Machine Language (binary).

We will write out assembler in an existing language so we don't have the
bootstrapping problem (chicken-egg scenario) and just output the binary code
that we know Hack machine uses. This is called cross-compiling: writing code on
another computer (here ours) and compiling to be executable on another cpu
(Hack cpu).

Assembler program steps:
1. read next asm cmd
1. break into different fields
1. lookup binary code for each
1. combine into single machine lang cmd
1. output this machien lang command
1. continue until EOF

## Step: read next asm command

Ignore whitespace, comments, non-command characters is the tricky bit,
otherwise fairly straightforward.

e.g. from asm command
```
Load R1, 18
```
We load this into an array of characters, literally store
'l','o','a','d','','r','1'...

## Step 2: break list of chars into different fields.

From 'Load R1, 18' break into 3 different sub-strings. Each sub-string is a
array of chars.

## Step 3: lookup binary for each field

Command     Opcode
Add         10010
Load        11001
...         ...

This is specified by the lang spec and a bunch of tables already worked out.

## Step 4: combine codes into single machine lang command

e.g., sometimes we need to pad the opcode or do something extra to it to meet
the machine language spec.

## Step 5: output the machine lang command

e.g.
```
1100101000010010
```

To a file or stdout, etc., according to machine lang. file format spec. So we
take the binary instruction and translate if needed to whatever format the
machine expects for an executable, for instance ELF binaries on Linux have diff
header than Windows, etc.

## Handling Symbols in Assembler

Symbols are used for:
* labels e.g., JMP loop (line in the program)
* Variables e.g. Load R1, weight (here it's a constant loaded into some
  register)

Assembler must replace names with actual addresses. We do by maintained
translation table between symbol to address, e.g.:

Symbol  Address
weight  5782
loop    673

### Allocation of variables

First time we encounter a symbol not in table: we need to find next mem
location available (how it does this should be defined by the asm spec) and
assign that mem address to the symbol in our table.

Handling labels: asm has to remember the location of labels for reuse, so we
store address of label in our table for lookup.

Forward Reference issue: sometimes we use 'JMP foo' before foo is even defined,
to handle these we could, possible solutions:

1. Leave symbol address blank in table until label appears then fix
1. In first pass just figure out all addresses (usually easily to code this)


# Unit 6.2: The Hack Assembly Language

## Then tranlator's challenge

 Given program in symbolic source language, we have to translate it into target
 cpu machine language.

## 6.2.1 Translating A-instruction

symbolic syntax:
@value
e.g.,
@21

Rules:
* non-negative decimal constant, or
* symbol referring to such a constant

Binary syntax:
0 followed by combination of 1s and 0s, e.g.
0000 0000 0001 0101 = @21

## Translating C-instruction

symbolic syntax:
dest = comp; jump

Binary syntax:
111 a c1 c2 c3 c4 c5 c6 d1 d2 d3 j1 j2 j3

Explained, briefly:
* the 'comp' part is represented by c1-c6 and has a table of possible
combinations mapping to symbolic syntax, e.g., 000 010 = D+A
* the 'dest' part is represent by bits d1-d3 and also have a table mapping
possible combinations to symbolic syntax, e.g., 010 = D
* the 'jump' part is represented by bits j1-j3 and has table of possible
  combinations mapping to symbolic syntax, e.g., 001 = JGT

## Translation pre-defined symbols

Built-in Hack pre-defined symbols are straighforward conversions to decimal
values, which in turn we translate into binary representation.

symbol      value       symbol      value
R0          0           sp          0
R1          1           LCL         1
...         ...         THIS        3
R15         15          THAT        4
SCREEN      16384       KBD         24576

(label) : label declaration
@varName : var declaration

## Challenges

Challenges in writing the assembler will be handling:

1. White space: blank lines, comments, commas, etc.
1. Instructions
1. Symbols

First we will write an assembler for Hack asm programs without symbols to make
the task easier, later we will handle symbols.


# Unit 6.3: The Assembly Process - Handling Instructions

Developing basic assembler that does not translate symbols, so only works with
symbol-less hack programs. In 6.4 we will add symbol ability.

## Translating A-instructions

Mostly covered in 6.2.1 already (see that heading).

If value is decimal constant: generate the equivalent 15-bit binary constant
(MSB is always 0 in A-instructions, remember) and then add/append bits to pad
it out to full width needed by machine.

Hack Symbolic            Hack binary machine lang
@2                       0000 0000 0010

If value is symbol? We will deal with that later, in next unit.

## Translating C-Instructions

See previous 6.2.2 already covered drawings/graphs.

Example:
symbolic Hack               Hack machine lang
MD=D+1

Every c-instruction has 3 fields:
1. MD = destination field
1. D+1 = computation field
1. null = jump field (no jump in this one)

The 'parser' of assembler will 'chop' these symbolic statements into
fields and then translate them.
                                (just look these up in table)
Symbolic Hack                   Hack machine lang field
opcode: c-instruction           1110 (111 always for c-instr an 0 for 'a' field
here)
comp field: D+1                 011111
dest field: MD                  011
jump field: null                000

Then we just put them together:
1110 0111 1101 1000

The 'a' field will be either 1 or 0 depending on where the 'comp' part is
listed in the table, look at the bottom, one column contains a number of funcs
performed when a=0 and there is another column of funcs for when a=1. When a=1
we peform the same comp as when a=0, we just M instead of A register in the
computation.

Quiz:
binary value of MD=A-1;JGE?

opcode: c-instruction           1110
comp: A-1                       110010
dest: MD                        011
jump: JGE                       011

Answer:
1110 1100 1001 1 011
cins cbits  dest jump

For each instruction:
1. Parse: break into underlying fields
1. A-instruction: translate decimal into binary value: done.
1. Not A-instruction, C-instruction.
    1. Foreach field in instruction, generate the binary code
1. Assemble binary codes into complete 16-bit machine instruction

# Unit 6.4: The Assembly Process - Handling Symbols

## Handling Symbols

1. variable symbols: represent mem locations where programmer wants to maintain
values.
1. Label symbols: represent destinations of goto instructions.
1. pre-defined symbols: special mem locations

### Pre-defined symbols

23 pre-defined symbols in Hack spec.

Only used in A-instructions (@predefinedsymbol), so we just replace symbol with
decimal number and then we can just translate to binary from that.

### Label symbols
Used to label goto commands. e.g. "(FOO)"

This defines symbol FOO to refer to mem location holding the next instruction
in the program. Therefore addressing it with like:
```
@LOOP
0;JMP
```
Make address of mem location LOOP the next instruction. So if LOOP was
instruction number 4 in the program then @LOOP means we replace labelSymbol
with its decimal value, andthen translate the decimal value to a binary value.

### variable symbols

Any symbol xxx which is not pre-defined elsewhere using the (xxx) directive (to
make it a label), is therefore treated as a variable. It is given a free mem
location and put in the symbols table.

```
@sum
M=0 // sum = 0
```

Each var assigned unique mem address, starting at 16 (designed by teachers that
way). So two vars in a program would be @16 and @17 in decimal.

Translating:
* if haven't seen this symbol before (i.e., not in table) assign a unique mem
  address starting from 16 and choose first free, e.g., @foobar given address
  16 if not other vars in program.
* Replace @foobar with its value in decimal

## symbol table

Data structure table to use symbol=value pairs. Populated as assembler runs
through the source code.

## Steps to build table

"First Pass" process--pre-defined symbols and label symbols:
1. Add all pre-defined symbols to an empty table (initialization step).
1. March through source file and look for line beginning with '(' to grab
label declarations, while doing this you are counting instructions so far
(i.e., source code line = 1 instruction, do NOT count comment or empty lines).
1. Add variable symbol to table with current instruction address, i.e., new
   label '(FOO)' found in source, is not in symbol table, so we add:
   ```
   symbol       value
   ...          ...
   FOO          24
   ```
   Here, 24 is the decimal count of the instruction in the source file,
   starting from 0-index, so 25th instruction in file will be @FOO.

"Second Pass" process -- variable symbols:
1. When we see a @foobar in the source code now, since we've already done the
   first pass, we know it is not a label symbol, and therefore it is a variable
   symbol.
1. Starting at value 16, we assign current variable symbol a decimal value, and
   then increment a free memory address counter by 1 so it now contains value
   17 for next new variable symbol.

We can toss the symbol table when all processing done as we won't need it after
that.

## The assembly process, step-by-step high-level logic

1. Initialization:
    1. Construct empty symbol table
    1. Add all pre-defined symbols to the symbol table
1. First Pass:
    1. For each instruction of the form "(xxx)": do
        1. Add the pair (xxx, address) to the symbol table, where address is
           the number of the instruction following (xxx)
1. Second Pass:
    1. Set n to 16
    1. For each instruction:
        1. If instruction is @symbol, look up symbol in table and
            1. if (symbol, value) found, use value to complete translation
            1. if (symbol, value) not found:
                1. Add (symbol, n) to the symbol table
                1. Use n to complete the instruction translation
                1. increment n, i.e., n++
        1. If instruction is C-instruction, complete instruction translation
        1. Write translated instruction to the output file

First pass, would give label symbols the following address in table:
```
    (START)
0       @MIDDLE
1        D=M
        // some comment!
        (MIDDLE)
2          @START
3          M=D
        (END)
4          @END
5          0;JMP
```

# Unit 6.4: Developing the Hack Assembler

## Tasks that need to be done

1. Reading and parsing commands
1. Converting mnemonics -> code
1. Handling symbols

### Reading and parsing commands

Requirement: start reading a file with a given name
Notes/Hints: in OOP maybe a Parser constructor object that accepts file name
string.

Requirement: Need to know how to read text files, i.e. opening,
reading/writing, handling errors in given fname, null errors, etc.

Requirement: Given good file handle, move to next 'command' in the file.
Notes/Hints: boolean hasMoreCommands(); // are we finished?
             void advance(); // get next command

Requirement: need to read one line at a time from a file.
Requirement: need to skip whitespace, including comments, and return only
actual lines with command instructions.
Notes/Hints: void stripWhitespace(); // remove ws and comments

Requirement: Get the 3 fields of the current command, i.e. dest=comp;jmp
Notes/Hints: save them for easy access by the rest of the program, like maybe a
fields object with the dest,comp,jmp fields? We need to save the type of the
current command, i.e., A-Command, C-Command, or Label

Example:
D=M+1;JGT
Seperated into 3 fields:
'D'             'M''+''1'       'J''G''T'
string dest();  string comp();  string jump();

@sum
's''u''m'
string label();

## Translating Mnemonic to Code Overview

We dont' need to know about lines in the file etc., it should already have been
done, we just need to translate each thing into machine language b looking up
its equivalent binary in the dest/comp/jump tables appended by 111a or 000a for
C/A instruction.

# Parse & Translating Pseudo Code

```
// Assum current cmd is
// D=M+1;JGT

string c = parser.comp(); // 'M+1'
string d = parser.dest(); // 'D'
string j = parser.jump(); // 'JGT'

string cc = code.comp(c); // '1110111'
string dd = code.dest(d); // '010'
string jj = code.jump(j); // '001'

string out = '111' + cc + dd + jj;
```

Parser class/fn breaks .asm lang commands into components
Code class/fns translate each given component to Hack binary format

# Symbol Table implementation details

Requirement: create a new empty table
Requirement: add (symbol, address) pair to the table
Requirement: be able to tell if table contains given symbol
Requirement: be able to fetch address associated with given symbol

# Overall Logic of Assembler

1. Initialization
    1. of Parser
    1. of Symbol Table
2. First Pass: read all commands, only paying attention to labels and updating
   the symbol table
3. Second Pass: restart reading and translating variable symbols and
   translating commands to binary

Main Loop:
    1. Get next asm cmd and parse it
    2. if a-instruction: translate symbols to binary and goto 1.
    3. if c-instruction: get code for each part (separate) and put them
    back together
    4. Output machine lang cmd to file.
