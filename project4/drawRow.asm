// drawRow.asm
// Practice drawing, fill entire first row
@SCREEN // this is constant 16384, mmap to the screen
D=A
@baseaddr
M=D // create var basebaseaddr that start with base basebaseaddress of screen

@R0
D=M // store user arg1
@totalcolumns
M=D

@cword
M=0

(LOOP)
    @cword
    D=M
    @totalcolumns
    D=D-M // if cword >= totalcolumns we are done this row
    @END
    D;JGT

    @baseaddr
    A=M     // store pointer
    M=-1 // blacken 16-bits by putting in binary all 1s

    @cword
    M=M+1 // increment to next Word, 1 address forward
    @1
    D=A
    @baseaddr
    M=D+M
    @LOOP
    0;JMP
(END)
    @END
    0;JMP
