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


