// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.
@R0 // save first argument into a variable (compiler will put this in addr 16)
D=M
@arg // @16
M=D

@R1 // save second argument into another variable
D=M
@arg2 // @17
M=D

// counter and sum variables
@i // @18
M=1
@sum // @19
M=0

// Fail early with cases where either argument is 0
// because anything times 0 is just 0, early exit
@arg // @16
D=M
@LOOPEND
D;JEQ // if arg is 0 end here and return 0

@arg2
D=M
@LOOPEND
D;JEQ // if arg2 is 0 end here and return 0

// arguments ok
// sum will start as equal to arg
@arg
D=M
@sum
M=D

(LOOP)
    @i          // end condition is when i = arg2, i.e., i-arg2 = 0
    D=M
    @arg2
    D=D-M       // current i value minus arg2 value i.e, 3 - 4 = -1
    @LOOPEND
    D;JEQ

    @sum        // continue loop, i is less than arg2 still
    D=M
    @arg
    D=D+M       // sum=sum+arg, i.e., if arg is 3 keep adding 3 each loop

    @sum        // store new sum back into sum
    M=D

    @i          // i++ for next iteration
    M=M+1

    @LOOP       // unconditional jump back to LOOP label
    0;JMP

(LOOPEND)
    @sum        // store total sum value into R2 for user
    D=M
    @R2
    M=D

(END)           // loop forever at program end
    @END
    0;JMP
