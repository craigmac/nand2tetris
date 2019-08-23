// test.asm
@SCREEN // this is constant 16384, mmap to the screen
D=A
@baseaddr
M=D // create var basebaseaddr that start with base basebaseaddress of screen

@8192
D=A
@endofscreen
M=D

@i
M=0

(LOOP)
    @i
    D=M
    @endofscreen
    D=D-M // if i > endofscreen we are done filling
    @END
    D;JGT

    @baseaddr
    A=M     // store pointer
    M=-1 // blacken 16-bits by putting in binary all 1s

    @i
    M=M+1
    @1
    D=A
    @baseaddr
    M=D+M
    @LOOP
    0;JMP
(END)
    @END
    0;JMP
