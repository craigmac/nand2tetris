@SCREEN // this is constant 16384, mmap to the screen
D=A
@addr // @16
M=D // create var baseaddr that start with base baseaddress of screen

// 32 * 255 (0-index, so 0-255 is 256) = 8160
@8160
D=A
@16384
D=D+A
@endofscreen // @17, should be 24,544
M=D

(LOOP)
    @addr // @16, starts at 16384
    D=M
    @endofscreen // @17, 24544 value
    D=D-M
    @END
    D;JGT  // i.e.,

    @addr // @16384, pointer value to start of screen memory map
    A=M  // store in A pointer to value at addr, aka A now 16384, @addr itself
         // is at @16
    M=-1 // sets value of A (@16384) to -1, which paints 16-bits of black in
        // top-left corner of the screen output

    // work to increment the pointer stored in @addr (@16 internally), to point
    // to the next Word. Each step of 1 address is RAM[n] where n holds a Word,
    // aka 16bits
    @1
    D=A // store 1 as data
    @addr
    M=D+M // set value at addr now to be 1+previous value, aka 16385 on first pass

    @LOOP
    0;JMP
(END)
    @END
    0;JMP
