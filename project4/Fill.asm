// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed.
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.
@SCREEN // @16384 constant
D=A     // save base address pointer
@addr // @16, create var that will store pointer to base of display mmap
M=D

// 32 words in a row * 255 rows = 8192bytes aka 8kb (0-255 is actually 256 bc of 0 index)
// 8192 + 16384 (screen base start addr) = 24,576 but we can't write at that address bc
// that's the KBD addr, so save one byte at end for that.
// KBD is @24576, so our total limit for SCREEN mmap ends at @24575
@8191
D=A         // save as data size we want to add to SCREEN base addr
@SCREEN     // constant @16384
D=D+A       // total value of 24575, with 1 byte reserved at 24576 for KBD
@endofscreen // @17, save above as symbol
M=D

(LOOP)
    // need to reset addr at start of each loop to repeat from beginning
    @SCREEN
    D=A
    @addr
    M=D

    @KBD // scan keycode
    D=M
    @PAINTBLACKLOOP
    D;JGT
    @PAINTWHITELOOP
    D;JGE

(PAINTBLACKLOOP)
    @addr // @16, starts at 16384
    D=M
    @endofscreen // @17, 24575
    D=D-M
    @LOOP
    D;JGT

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

    @PAINTBLACKLOOP
    0;JMP

(PAINTWHITELOOP)
    @addr
    D=M
    @endofscreen
    D=D-M
    @LOOP
    D;JGT
    @addr
    A=M
    M=0
    @1
    D=A
    @addr
    M=D+M
    @PAINTWHITELOOP
    0;JMP
