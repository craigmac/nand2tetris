// forLoop.asm

/*
 * Given n=10
 * and
 * arr=100
 *
 * computes:
 * for (i=0; i<n; i++) {
 *      arr[i] = -1;
 * }
 */

@100
D=A
@n
M=D

@i
M=0

(LOOP)
    // if i==n goto END
    @i
    D=M
    @n
    D=D-M
    @END
    D;JEQ // jump to END if D is equal to 0 (i-n is 0 means they are equal)

    // RAM[arr+i] = -1 part, uses bases address of RAM[arr] and adds
    // offset of index i to it and saves that into Address register as pointer
    @arr
    D=M
    @i
    A=D+M
    M=-1

    // i++
    @i
    M=M+1
    @LOOP
    0;JMP

(END)
    @END
    0;JMP
