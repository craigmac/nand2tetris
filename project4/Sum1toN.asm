// Sum1toN.asm
/* Computes:
 * 1 + 2 ... + n
 */

 @R0 // select R0, this is where user will put value of N before running this
    // application
 D=M

 @n // create & select variable 'n', compiler will find empty register
    // and use every further @n to select said register. This creates a variable
    // because compiler will look and see there is no (n) label declaration so
    // it is therefore made a variable
 M=D  // n=whatever user entered into R0

 @i // create and select var 'i'
 M=1 // now i=1

 @sum // create and select var 'sum'
 M=0 // set sum=0

(LOOP) // label declaration, can now target this with @LOOP
    @i
    D=M // store current i value in d register
    @n
    D=D-M // decrement the n value
    @STOP // label to for jump instruction that follows
    D;JGT // basically, if i > n goto STOP because say i=4 and n=6 on this
        // iteration, D would be -2 and thus not greater than 0. When i=7 and
        // n=6 then D=1 which is greater than 0 (JGT) and now jump to STOP
    @sum // continue loop
    D=M  // save current sum
    @i
    D=D+M // sum is now sum + current value of i
    @sum
    M=D  // save the new sum back to sum variable
    @i
    M=M+1 // i++ for next loop iteration
    @LOOP
    0;JMP // uncond. jump to loop start

(STOP)
    @sum
    D=M // grab current sum value
    @R1
    M=D // store sum total into R1 for user

(END) // typical best practice of infinite loop at end to prevent no-op slide
    // attack/bugs (program counter continuing past these instructions
    // unfettered)
    @END
    0;JMP
