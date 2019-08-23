# Week 4 -- Machine Language

## Unit 4.3 The Hack Computer and Machine Language

Whenever we want to work with a memory address we first need to use
'@N' instruction, e.g., @1. This is called the A-instruction (Addressing
instruction) and the value is stored in the A-register. In the M-register,
m for memory, will be stored the address we are currently addressing (only
one 16-bit address can be worked on at a time).

```
@1
M=A-1;JEQ
```

Above sets A register to 1.
Second line computes A-1, which is 0.
We store 0 in M register, which is really RAM\[1\], the value of the A
register is still 1.
The JEQ jump directive checks if computation was equal to 0.
It was, so next instruction will be the value stored in the A register, which
is 1, meaning we goto address 1.

### C-Instruction
This is the workhorse of the language. The jumping directives.

syntax:
destination = computation; jumpdirective

(both dest and jump are optional)

To write unconditional jump do:
0; JMP

We need the 0; there because language requires 'computation' part so we
just compute 0 and then JMP to whatever instruction address is in A-register.

computation can be one of:
* 0
* 1
* -1
* D
* A, M
* !D
* !A, !M
* -D
* -A, -M
* D+1
* A+1, M+1
* D-1
* A-1, M-1
* D+A, D+M
* D-A, D-M
* A-D, M-D
* D&A, D&M
* D|A, D|M

destination can be:
(unique to Hack is we can store in multiple registers at once)
* null
* M
* D
* MD
* A
* AM
* AD
* AMD

Jumpdirective can be:
* null
* JGT
* JEQ
* JGE
* JLT
* JNE
* JLE
* JMP

## Unit 4.4: Hack Language Specification

## Unit 4.5: Input/Ouput
How we use machine language to manipulate I/O devices.

1. Screen
2. Keyboard


### Screen

Memory Map: sequence of 16-bit values (aka Word, as that is
the size the cpu in our architecture uses).

Screen memory map: designated area of RAM where physical screen fetches
data from. We affect the screen by manipulating the screen memory map.

Display is continously refreshed with contents from this memory map.

Display: 256 x 512 black/white pixels.

Display Unit is made up of:
8k of 16bit values (Words).
8kb of Words (16bit) = ~13,000
8 * 1024k (actual kb value, not 1000) = 8192
8192 * 16 = 131072 bits
This equals the same as 256x512 resolution.
256 * 512 = 131072 bits.

So for every pixel on Display Unit we have a bit that
represents that pixel with a value of either 1 or 0 (on/off,
black/white).

2-D abstraction of screen is 0-255 rows with each one
having 0-511 columns.

Display Unit (256 by 512, black and white) diagram:
    01234567   ... 511
0   11110101   ...  1
1
...
255

Screen Memory Map diagram:
Address     Words (16-bits)
(16384) 0   1111010100000000
        1   0000000000000000
        ...
        ...
        31  0011000000000001
(second row begins, each row has 32x16=512)
        32  0000101000000000
        33  0000000000000000
        ...
        ..
       8191 1011010100000000

We end here at 8191 address because that is last
value of 8kb in size. 16384 is the base address
here of the screen memory map within overall RAM.

You have to grab the whole Word, 16bits, to target 1 bit in
the word. So read/write operations area always 16bit operations.

You take a Word out, manipulate it and write it back.

The first 32 words in above memory map correspond
to the first row in the display unit diagram. So to find a
specific row you just do 32 * row number you are after,
e.g. third row = 32 word/row * 3 row = 96th word. Now that
is the 96th from the base address (start of where screen
is memory mapped). So if you know the base address then
it's just adding 96 to that to get the first Word of the
third row on the display unit, a 16bit value).

### Setting a specific pixel on or off
To set pixel (row,col) on/off:

Here the target Word is based off starting from the base
address of Screen.
1. word = Screen[32\*row + col/16]

But if we are addressing from larger context of RAM as a
whole, the target Word will be:
1. word = RAM[16384 + 32\*row + col/16]
2. Set the (col%16)th bit of Word to 0 or 1. Turns out
a specific bit of the Word is the col modulo 16 (the
remainder of a division).
3. Take the result and commit the Word back to the RAM

Quiz:
To change row4, column 55 you would retrieve?

Answer:
targetRegister = 32 * 4 + 55/16
Integer division, so we throw away .4375 of division result
targetRegisterAddress = 128 + 3
targetRegisterAddress = 131

Screen[targetRegisterAddress], 7th bit (col 55%16)

Hardware Simulator test:
Screen chip:
Input pins:
in[16] // what to write
load    // write-enable flag
address[13]

output pins:
out[16]

Say we wish turn the first 16 pixels of row 3 to black:
Get to register which represents the first 16bits of
row 3 -> 3rd row * 32 registers/words in a row = 96th
register.

steps:
address = 96
load = 1
in = 1111 1111 1111 1111 (aka -1 in decimal using 2s complement)

### Keyboard I/O

Keyboard connects to a keyboard memory map in RAM.

You only need 16 bits, 1 register, named Keyboard.
When key pressed, scancode e.g. 75 for letter k (agreed
upon value, ascii table) travels down the wire and enters
the keyboard memory map in binary.

#### Hack Character Set we will use

Key Code
none 0
0   48
1   49
..  ..
9   57
A   65
..  ..
Z   90
(space) 32
| 33
" 34
hash 35
$ 36
% 37
& 38
' 39
( 40
) 41
asterisk 42
plus 43
, 44
- 45
. 46
/ 47
: 58
; 59
< 60
= 61
closebracket 62
? 63
@ 64
newline 128
backspace 129
left 130
up  131
right 132
down 133
home 134
end 135
Page up 136
page down 137
insert 138
delete 139
esc 140
f1 141
...
f12 152

Probe RAM[24576] for keycode value, this is where
the keyboard memory map is stored in Hack cpu.

## Unit 4.6: Hack Programming Part 1

2 instructions in Hack lang:

1. A-instruction: set value of A register
2. C-instruction: 3 diff things: compute value of an
expression, store the value of the computation in a destination,
and optionally based on computation, jump to a location. (goto)

Registers of interest:
D: data register
A: address or data register
M: value at current selected memory register, M = RAM[A]

```
// To store register 10 in D, have to do it indirectly
@10 // select register 10
D=A // data register equal to 10

// D++
D=D+1

// D=RAM[17]
@17 // select address 17
D=M // data register equal to value at address 17, M

// RAM[17]=0
@17 // select address 17
M=0 // set value of address 17 to 0

// RAM[17]=10
@10 // select 10
D=A // data reg is equal to constant 10
@17 // select 17
M=D // value at 17 equal to constant 10

// RAM[5] = RAM[3]
@3 // select 3
D=M // data equal to value at 3 address
@5 // select 5
M=D // set value of address 5 using value in D
(whatever value is at RAM[3] which we don't know here)
```

Quiz:
Which of the following lines completes the program so that
RAM[11]=10?

@10 // select 10, M = RAM[10]
D=A // data equal to constant 10
A=D+1 // Address register equal to 11, our target

Answer:
M=D // value at A, now RAM[11], equal to 10

We need to change RAM[11] and since A=11, and M is
defined as RAM[A], we need to access M. Value 10 is
stored in D, so we just use M=D, aka RAM[A]=10.

### Add two numbers in Hack
//Computes RAM[2] = RAM[0] + RAM[1], arbitrary locations

```
@0
D=M // D = RAM[0], stores in D current value

@1
D=D+M // D = D + RAM[1], stores in D previous value
      // plus value at new ram location set by @1

@2
M=D // RAM[2] = D, stores at @2, value of previous
    // computation, stored in D register.
```

To stop Program Counter from infinitely continuing from
last M=D instruction line, it's best practice to end
every program with an infinitely unconditional jmp loop,
e.g.

```
@6
0;JMP
```
Where @6 is written on the 6th line, just make sure it is
after all your executed code or you'll be stuck inside your
application in an infinite loop!

### Built-in symbols of Hack language
symbol      Value
R0          0
R1          1
R2          2
...         ...
R15         15
SCREEN      16384 (base address of mem map for screen)
KBD         24576 (base address of mem map for keyboard)

Others not used in this course, but in Part 2 of course:
SP          0
LCL         1
ARG         2
THIS        3
THAT        4

R0..R15 are used to denote virtual registers:
```
// Set RAM[5]=15
@15
D=A // use D as data register

@5
M=D // use @5 to select register 5
```

Problem is the syntax, in first instruction set we use the A
register as a DATA register, storing 15 in A then moving it
to D to use as value to set @5 to in second set of instructions.

In second set we use the @ symbol here not to get a constant
value but to select memory register number 5. This is opposite
of what first set did, but with same syntax!

So when we see @N in a program we don't know for sure if
programmer means to use that N as a constant data value or
is meaning to use it to select a memory register N.

Better style to make it more readable is use symbols they've
built in
```
// RAM[5]=15
@15
D=A

@R5
M=D
```

With this style, if we are consistent with it, we can immediately
see the first @ is being used to store constant value, and
@R5 (which just translates to @5 internally) means we are selecting
memory register. It is more clear to reader what programmer
is doing here with @ symbols if you use @Rn to select a memory
register and only use @0, @1, for storing a constant value.

Hack is case-sensitive!

## Unit 4.7: Hack Programming Part 2

This unit: branching, variables, and iteration

### Branching

Done using goto, basically

```
// Computes: if R0 > 0
//              R1=1
//           else
//              R1=0
@R0
D=M // set D to whatever value is in R0 (not the address)

@8      // select location we'd like to jump to in next instruction
D;JGT   // this says if D is greater than 0 goto 8 (8th instruction)

@R1     // else path, set R1=0 and jump to end of program which loops forever
M=0     // set R1 value to 0 aka RAM[1]=0
@10
0;JMP   // end of program

@R1     // goto 8 lands here, 8th line of code, ignoring whitespace; 0-indexed
M=1     // set R1 value to 1, this is the if R0>0 then R1=1 part

@10
0;JMP   // end of file infinite loop
```

Labels:
To make jumping much more clear, we can instead use symbolic labels that are
translated from @LABEL to @n, where n is the instruction number following
the '(LABEL)' declaration

```
[...]

@POSITIVE // using a label, just like saying @8
D;JGT

[...]

(POSITIVE) // label declaration for this position (i.e., @8)
@R1 // label declarations are not translated, this is the actual @8
M=1

(END) // declare below instruction to be a label that we can target
@END  // select self basically
0;JMP // unconditional jump to @END--infinite loop
```

### Variables

In Hack only 16-bit values to worry about, 1 single Register can be
used to represent a variable.

```
//flip.asm
/* flips values of RAM[0] and RAM[1]
 * temp = R1
 * R1 = R0
 * R0 = temp
 */

@R1
D=M
@temp // declare variable named 'temp'
M=D // temp=R1

@R0
D=M
@R1
M=D // R1=R0

@temp
D=M
@R0
M=D // R0=temp

(END)
@END
0;JMP
```
@temp here means: "find some available memory register (say register n),
and use it to represent the variable 'temp'. So from now on, each time
we see @temp in the program, translate it into @n.

Translation process honours this contract:
"A reference to a symbol that has no corresponding label declaration, e.g.
(MYLABEL) is treated as a reference to a variable. Variables are allocated
to the RAM from address 16 onward."

### Iterative Processing

Example: 1 + 2 + 3 + ... + n

pseudo code:
LOOP:
    if i > n goto STOP
    sum = sum + i
    i = i + i
    goto LOOP
STOP:
    R1 = sum

```
// Sum1toN.asm

@R0 // select register 0
D=M // set data register to value of R0
@n  // create & select variable 'n'
M=D // n = R0
@i  // create & select variable 'i'
M=1 // variable i = 1
@sum // create & select variable 'sum'
M=0 // sum = 0

(LOOP) // label declaration, can now be targeted with @LOOP
    @i // select variable 'i'
    D=M // set d register to value in 'i'
    @n // select variable 'n'
    D=D-M // decrement current value of 'i' by value in 'n' variable
    @STOP // select label STOP to jump to on result of next instruction
    D;JGT // if i > n goto STOP

    @sum
    D=M
    @i
    D=D+M
    @sum
    M=D // sum=sum+i
    @i
    M=M+1 // i=i+1
    @LOOP
    0;JMP // unconditionally jump to (LOOP) again

(STOP)
    @sum
    D=M
    @R1
    @R1
    M=D // RAM[1]=sum

(END)
    @END
    0;JMP

```
## Unit 4.8: Hack Programming Part 3

Pointers and I/O

### Pointers and I/O devices

The notion of arrays to the compiler is just a segment of memory, with a
base address and a length given.

Variables that store memory addresses, like arr and i, are called
pointers.

Hack language pointer logic: whenever we have to access memory using
a pointer, we need an instruction like A=M.

Typical pointer semantics:
"Set the address register to the contents of some memory register."

How to set and array of 10 elements to -1:
```
// suppose that arr=100 and n=10
// compiler will set arr = register 16, n to register 17, and i to reg. 18,
// because contract is that it will start assigning @variables at register
// 16+.
@100 // arr = 100
D=A // save 100 to data register
@arr
M=D // set variable arr to value 100

// n=10 part
@10
D=A // save as constant 10 in data register
@n
M=D // n=10

// now loop part starts (for i=0; i<n; i++; arr[i] = -1)
@i
M=0

(LOOP)
    // if i==n goto END
    @i
    D=M
    @n
    D=D-M
    @END
    D;JEQ // jump to END if D is equal to 0 (aka i-n is 0, equal!)

    // RAM[arr+i] = -1 part, use base address of RAM[arr] and add
    // offset of i to it and set that address value to -1
    @arr
    D=M
    @i
    A=D+M // Use A reg. to store value of arr + value of i, which is RAM[arr+i]
    M=-1 // set this address, RAM[A], which was set to point to RAM[arr+i],
        // to constant value -1

    // i++
    @i
    M=M+1
    @LOOP
    0;JMP

(END)
    @END
    0;JMP
```

### I/O

Hack RAM:
0-16383: data memory (16k)
16384-24575: Screen mmap (8k)
24,576: Keyboard mmap (single register)

Drawing a rectangle pseudo code:
Screen top-left starts at mmap value 16384

```
n = rows given by user
for (i=0; i <n; i++) {
    draw 16 black pixels at the beginning of row i
    }

addr = SCREEN // base address
n = RAM[0] // save value
i = 0 // iteration count

as long as i has not reach n, set ram address to -1 (all 1s, black),
and then advance to next row by adding 32 (size of a row).

pseudo code:
LOOP:
    if i > n goto END
    RAM[addr] = -1
    // next row, each row is 32 Words remember (32x16bits = 512 pixels)
    addr = addr + 32
    i = i + 1
    goto LOOP
END:
    goto END


```

### Handling the keyboard

keycodes storing in 24576 register.

Read contents of RAM[24576] which has predefined label @KBD

```
@KBD
D=M // Save keycode value, if 0 no key is pressed
```

## Unit 4.9: Project 4 Overview

Tasks:
* Write a simple algebraic program
* Write a simple interactive program

### 1st Program: Mult

Mult performs R2 = R0 * R1

So if user sets RAM[0] to 6 and RAM[1] to 7, RAM[2] after running mult.asm
will be 42.

### 2nd Program: Fill

Listen to keyboard, and as long as no key pressed nothing happens,
it any key pressed, screen is fully blackened, when key lifted (no
keycode) screen becomes white again. Infinite loop listening to keyboard
and responding.

Addressing the memory requires working with pointers. Loop with pointers to
address every memory address in the screen mmap.

Testing:
select "no animation"
test it manual by pressing/unpressing keys

### Program development process

1.Write out pseudo code.
1.Write/edit the program using text editor translating pseudo code into
Hack assembly.
1.Load file into cpu emulator and run it.

## Unit 4.10: Perspectives
