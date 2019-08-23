// Program: Signum.asm
// Computes:
/*
 if R0 > 0:
    R1=1
 else:
    R1=0
*/

@R0
D=M // save value of RAM[0] to D register

@IF-POSITIVE // using a label as target
D;JGT

@R1
M=0
@END
0;JMP

(IF-POSITIVE) // label declaration, means next line @8 is easier targetted
@R1
M=1

(END)
@END
0;JMP
