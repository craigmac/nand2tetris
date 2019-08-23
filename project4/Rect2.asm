@SCREEN // this is constant 16384, mmap to the screen
D=A
@baseaddr
M=D // create var baseaddr that start with base address of screen

@R0 // user stores rows in here
D=M
@n // @16
M=D // n = RAM[0]

@i // @17
M=0 // i=0

@j // @18
M=0

@R1 // user stores columns in here
D=M
@cols // @19
M=D

(LOOP)
    @i
    D=M // save current i
    @n  // desired total rows
    D=D-M
    @END
    D;JGT // if i>n goto END

    //@baseaddr // starts as 16384
    //A=M // store pointer
    (INNERLOOP) // loop 32 times here to fill columns
        @j          // jump to setup for next row if j > cols (user set)
        D=M
        @cols
        D=D-M
        @NEXTROW
        D;JGT
        @baseaddr
        M=M+1
        M=-1 // RAM[baseaddr]=1111 1111 1111 1111 (all black)
        @j
        M=M+1 // j++
        @INNERLOOP
        0;JMP
    (NEXTROW)     // setup for next row
    @i
    M=M+1
    @32
    D=A // store 32 as data value. Why can't we just do D=32 directly here?
    @baseaddr
    M=D+M // set value of baseaddr now to be baseaddr+32, aka jump to next row
    @LOOP
    0;JMP
(END)
    @END
    0;JMP
