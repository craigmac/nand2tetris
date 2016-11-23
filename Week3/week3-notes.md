# Week 3 -- nand2tetris.org notes

This week we focus on building the main memory, the RAM, starting
by building flip-flop gates, then we move on to 1-bit registers, and
then proceed to n-bit registers.

Processing chips are based on combinational logic, e.g., x + y, outside of time,
but memory chips logic requires a clock-based sequential logic. We begin
by exploring the theoretical background of clock cycles.

## Unit 3.1 Sequential Logic
Two reasons 'time' comes into our hardware:
1. To reuse our hardware to do the same function, e.g. adding two numbers,
many times in a loop.
2. Remembering 'state' (memory, counters) such as intermediate results
while computing in a for-loop.

We use an oscillating clock for discrete states. Each cycle will be treated as one
integer time unit, e.g. t = 1, next cycle t = 2. Nothing changes WITHIN the cycle,
only at the end/beginning of next cycle. We use this manufactured integer time unit
to stabilize the computations.

t = time unit
Combinatorial logic: out[t] = function(in[t])
Sequential logic: out[t] = function(in[t-1])

The t-1 means that we remember things from last cycle and based on the previous
time step we compute.


# Unit 3.2 - Flip Flops

Gate that can flip between two states are called flip-flops. They are several
variants of flip-flops, and we will used what is called a data flip-flop,
or DFF, which has a 1 bit input and 1 bit output. It also has a clock input
that continously changes according to the master clock's signal.

What they do is remember one bit of information from t-1 so it can be used
at time t (let's say t is 'now'). Basically the DFF simply outputs the input
value from the previous time unit (t-1).

At the 'end of time' t-1, it can be at two states: remembering 0, or
remembering 1. It remembers by just flipping between these two states.

The 'state' then, either 1 or 0, is remembered between time units.

## clocked Data Flip-Flop

circuit diagram (t=time units in integer):

           ------
in -----> | DFF  | -----> out
           ------
	  out[t] = in[t-1]

DFF basically remembers input from last time unit (t-1), and outputs
it in the next time unit.

Memory will be build out of an array of DFF gates, which will then
accept a 'load bit' input will be used to signal whether to remember
the value for the next time unit or to forget it.

The physical implementation of DFF is an intricate task and based on
connecting several elementary logic gates using feedback loops (can be
done using just Nand gates). However, in this course we will take DFFs
for granted and abstract them away, choosing not to build them and
treat them as a primitive building block.

## Registers
A register is used to 'store' a value over time, implementing out(t) = out(t-1)

### Difference between register and DFF
A DFF can only ouput its previous input, i.e. out(t) = in(t-1).
A register can be implemented from a DFF by feeding the output of the DFF
back into its input, created a loop. With this loop complete, we now have
a device that at any time t will echo its output from t-1.

To complete the register we need to be able to alter the loop storage, so
that we can manipulate what it stores externally. We can do this by introducing
a Mux chip and selecting based on an input we will call 'load' which indicates
whether to change the current storage value, or to leave it be.


load -----
         |
	 |
in ----> Mux ---> DFF -----> out
         ^             |
	 | old         |
	 ---------------

Diagram as a function:
if load(t-1) then out(t)=in(t-1), else out(t)=out(t-1)

In english:
If we want to store a new value, we put this value in the in input
and set the load bit to 1, if we want the register to keep storing
the same value, we set the load bit to 0. Basically the 'load'
will serve as the sel bit on the Mux to choose between 'in' and 'out'.

## w-bit Register with random access (RAM)

We can create an w-bit (arbitrary lenght) register by using an array of
1bit registers chained together.

                load
		 |
    w            |                   w
in -/--> Reg0 Reg1 Reg2 ... Regw-1 --/--> out

Now we need ability to address any register directly, which
will make this array of registers now RAM.

We do this by assigning each word in the n-register RAM a unique
address (integer between 0 to n-1), by which it will be addressed. So given
address j, we need to be capable of selecting individual register address j
in the register array.

In classical RAM, we do this with 3 inputs: data input, address input, and
a load bit. A read operation is load=0.

The design parameters of RAM:
1. data width -- the width (in bits usually) of each of its so called 'words'
2. size -- the number of 'words' the RAM contains.

Nowadays most RAMS words are 32 or 64 bit wide and sizes are millions plus.


## Counters
A counter is a sequential chip whose state is an integer number that increments
every time unit. Its function could be described as:
out(t) = out(t-1) + c
Where c is typically 1.

A typical CPU uses a program counter chip, whose output is intepreted as
the next address to be executed in the current program running.

It is implemented usually by combinbing in/out logic of standard register
with the combinatorial logic for adding a constant. Usually the counter will
have functionality to reset the count to zero, loading a new counting base
number (new address), or decrementing instead of incrementing.

* Important to remember: sequential chips always consist of a layer of DFFs
sandwiches between optional combinatorial logic chips. Sequential chips can
maintain state by means of internal feedback loops.

# Implementation notes

## RAM chips
For the Hack platform we will need to build the following RAM chips:
RAM8
RAM64
RAM512
RAM4K
RAM16K

RAM parameters:
Chip name: RAMn // n and k listed below in table
Inputs: in[16], address[k], load
Outputs: out[16]
Function: out(t)=RAM[address(t)](t)
	  If load(t-1) then
	     RAM[address(t-1)](t)=in(t-1)
Comment: '=' is a 16-bit operation.

chip	 n   	k
RAM8	 8	3
RAM64	 64	6
RAM512	 512	9
RAM4K	 4096	12
RAM16K	 16384	14

## Counter chip


              inc	load	reset
	       |	  |	  |
   w bits      |	  |	  |   w bits
in ---/-->     Program Counter Chip ----/---> out

Chip name: PC // 16-bit counter
Inputs: in[16], inc, load, reset
Outputs: out[16]
Function: If reset(t-1) then out(t)=0
	     else if load(t-1) then out(t)=in(t-1)
	     	  else if inc(t-1) then out(t)=out(t-1)+1
		       else out(t)=out(t-1)
Comment: '=' is 16-bit assignement
	 '+' is 16-bit arithmetic addition.

The in would be the base integer address, when we do reset, the in
value stays the same but the out would be 0, if we then did load
with say 527, then the output would be 527 until we either do
reset (0 output) or we set inc to 1, in that case it would be
528 for next cycle, and then 529, and continue incrementing the
out value until we switch off inc.

## n-Register Memory (RAM)
A 64-bit RAM can be built from an array of eight 8bit RAM chips.
To select a particular register we use a 6-bit address, say
xxxyyy. The Most Significant Bit (MSB), xxx, select one of the
RAM8 chips, and the LSB yyy select one of the registers within
the selected RAM8.

