// Rectangle.asm
// Draw a filled (black) rectangle on Screen starting from top-left position
// to a depth of RAM[0] pixels. User puts height of rectangle into RAM[0] and
// we use that to be the stopping row of the drawing loop.

@SCREEN // this is constant 16384, mmap to the screen
D=A
@addr
M=D // create var addr that start with base address of screen

@0
D=M
@n
M=D // n = RAM[0]

@i
M=0 // i=0

(LOOP)
    @i
    D=M
    @n
    D=D-M
    @END
    D;JGT // if i>n goto END

    @addr
    A=M // store pointer
    M=-1 // RAM[addr]=1111 1111 1111 1111 (all black)

    @i
    M=M+1 // i++
    @32
    D=A // store address 32 as data
    @addr
    M=D+M // set value of addr now to be addr+32, aka jump to next row
    @LOOP
    0;JMP
(END)
    @END
    0;JMP
