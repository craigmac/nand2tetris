# Basic set of chips
Xor -- if a !== b return 1, else 0
And -- if a && b return 1, else 0
Or -- if a || b return 1, else 0
Dmux -- (inputs: in, sel; outputs: a,b) -- if sel==0 then a=in,b=0, else a=0,b=in
Mux -- (inputs: a,b,sel; outputs: out) -- if sel==0, out=a, else out=b
Not -- (inputs: x) -- return !x

Most of the above come in 4/8Way variations and/or 8/16bit variations.

# ALU chipset

## Half-adder chip

truth table:
a b   sum	carry
0 0   0		0
0 1   1		0
1 0   1		0
1 1   0		1

Made with two 'primitive' chips: Xor and And:
HalfAdder -- (inputs: a,b; outputs: sum,carry):

Xor(a=a,b=b,out=sum);
And(a=a,b=b, out=carry);

## Full-adder chip

From the half-adder and an Xor we can make a FullAdder gate/chip:
(inputs: a,b,c; outputs:sum,carry)

HalfAdder(a=a,b=b,sum=absum,carry=abcarry);
HalfAdder(a=absum,b=c,sum=sum,carry=ccarry);
Xor(a=abcarry,b=ccarry,out=carry); // carry is 1 if inputs are equal

We first do halfadder on inputs a,b and save results as absum and abcarry.
Next we send absum and c into another halfadder. The output will be the
sum of all the inputs (a + b + c). We save the carry output of absum + c
as ccarry. Next see if there will be a carry output by checking if either
the abcarry or the ccarry was set, and if one was then the Xor output
will be set to 1, otherwise it's 0.

## ALU (Arithmetic Logic Unit)

Inputs: x[16bit], y[16bit], zx, nx, zy, ny, f, no
Outputs: out[16bit], zr (set if out == 0), ng (set if out < 0)

Computes one of the following functions based on the input flags (minus
x and y which are the values to perform on):
1. x+y
2. x-y
3. y-x
4. 0
5. 1
6. -1
7. x
8. y
9. -x
10. -y
11. !x
12. !y
13. x+1
14. y+1
15. x-1
16. y-1
17. x&y
18. x|y

Flag definitions:
zx (zero all the bits of x input)
nx (negate x input)
zy (zero all the bits of y input)
ny (negate y input)
f (if 1, out = x + y, else out = x & y (bitwise operation instead of addition))
no (if 1 negate output value going to out)

# 